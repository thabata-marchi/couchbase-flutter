import 'package:cbl/cbl.dart';

class CouchbaseService {
  AsyncDatabase? database;

  Future<void> init() async {
    database ??= await Database.openAsync('database');
  }

  Future<bool> add({
    required Map<String, dynamic> data,
    required String collectionName,
  }) async {
    final collection = await database?.createCollection(collectionName);

    if (collection != null) {
      final document = MutableDocument(data);
      return await collection.saveDocument(document);
    }

    return false;
  }

  Future<List<Map<String, dynamic>>> fetch({
    required String collenctionName,
    String? filter,
  }) async {
    await database?.createCollection(collenctionName);

    final query = await database?.createQuery(
        'SELECT META().id, * FROM $collenctionName ${filter != null ? 'WHERE $filter' : ''}');

    final result = await query?.execute();
    final results = await result?.allResults();

    final data = results
        ?.map((e) => {
              'id': e.string('id'),
              ...(e.toPlainMap()['checklist'] as Map<String, dynamic>),
            })
        .toList();

    return data ?? [];
  }
}
