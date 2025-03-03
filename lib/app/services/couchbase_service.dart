import 'dart:async';

import 'package:cbl/cbl.dart';
import 'package:checklist/app/utils/couchbase_contants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CouchbaseService {
  AsyncDatabase? database;
  AsyncReplicator? replicator;
  StreamSubscription<List<ConnectivityResult>>? networkConnection;

  Future<void> init() async {
    database ??= await Database.openAsync('database');
  }

  Future<void> startReplicator({
    required String collectionName,
    required Function() onSynced,
  }) async {
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final config = ReplicatorConfiguration(
        target: UrlEndpoint(
          Uri.parse(CouchbaseContants.publicConnectionUrl),
        ),
        authenticator: BasicAuthenticator(
          username: CouchbaseContants.userName,
          password: CouchbaseContants.password,
        ),
        // continuous -> Como ele vai fazer esta replicação, maneira contínua, de maneira única,
        // se eu definir como false, ele faz apenas uma vez e para de ouvir, se eu deixar como true,
        // ele vai ficar ouvindo ali várias e várias vezes, justamente para fazer esta replicação de maneira mais estruturada
        continuous: true,
        // enableAutoPurge: Como lidar com usuário, caso ele perca acesso aquele banco de dados, se o user perder o acesso
        // o que vai acontecer? Se ele perder o acesso, vamos apagar aquele banco de dados dele
        enableAutoPurge: true,
        replicatorType: ReplicatorType.pushAndPull,
      );

      config.addCollection(
        collection,
        CollectionConfiguration(
          channels: [CouchbaseContants.channel],
          conflictResolver: ConflictResolver.from(
            (conflict) {
              // Este caso é apenas resolvendo conflito na sincronização dos dados
              return conflict.remoteDocument ?? conflict.localDocument;
            },
          ),
        ),
      );

      replicator = await Replicator.createAsync(config);

      replicator?.addChangeListener(
        (change) {
          if (change.status.error != null) {
            print(
                'Ocorreu um erro de sincronização: ${change.status.error.toString()}');
          }
          if (change.status.activity == ReplicatorActivityLevel.idle) {
            print('ocorreu uma sincronização');
            onSynced();
          }
        },
      );
      await replicator?.start();
    }
  }

  void networkStatusListen() {
    networkConnection = Connectivity().onConnectivityChanged.listen(
      (events) {
        if (events.contains(ConnectivityResult.none)) {
          print('sem conexão com a internet');
          replicator?.stop();
        } else {
          print('conectados com a internet');
          replicator?.start();
        }
      },
    );
  }

  Future<bool> add({
    required Map<String, dynamic> data,
    required String collectionName,
  }) async {
    // Configuração banco local: final collection = await database?.createCollection(collectionName);
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );

    if (collection != null) {
      final document = MutableDocument(data);
      return await collection.saveDocument(
        document,
        ConcurrencyControl.lastWriteWins,
        // Este caso é apenas resolvendo conflito ao salvar os dados
        // Deu conflito, deixa salvo quem escreveu por último
      );
    }

    return false;
  }

  Future<List<Map<String, dynamic>>> fetch({
    required String collectionName,
    String? filter,
  }) async {
    await init();
    await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );

    final query = await database?.createQuery(
      'SELECT META().id, * FROM ${CouchbaseContants.scope}.$collectionName ${filter != null ? 'WHERE $filter' : ''}', // Antes quando só banco local, era apenas: $collectionName, não tinha: ${CouchbaseContants.scope}.$collectionName
    );
    final result = await query?.execute();
    final results = await result?.allResults();
    final data = results
        ?.map((e) => {
              'id': e.string('id'),
              ...(e.toPlainMap()[collectionName] as Map<String, dynamic>)
            })
        .toList();
    return data ?? [];
  }

  Future<bool> edit({
    required String collectionName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final doc = await collection.document(id);
      if (doc != null) {
        final mutableDoc = doc.toMutable();
        data.forEach(
          (key, value) {
            mutableDoc.setValue(value, key: key);
          },
        );
        final result = await collection.saveDocument(
          mutableDoc,
          ConcurrencyControl.lastWriteWins,
        );
        return result;
      }
    }
    return false;
  }

  Future<bool> delete({
    required String collectionName,
    required String id,
  }) async {
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final doc = await collection.document(id);
      if (doc != null) {
        final result = await collection.deleteDocument(
          doc,
          ConcurrencyControl.lastWriteWins,
        );
        return result;
      }
    }
    return false;
  }
}
