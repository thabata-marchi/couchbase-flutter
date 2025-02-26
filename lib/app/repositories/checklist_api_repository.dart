import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:checklist/app/services/couchbase_service.dart';

class ChecklistApiRepository implements ChecklistRepository {
  final CouchbaseService couchbaseService;
  ChecklistApiRepository({required this.couchbaseService});

  final collectionName = 'checklist';

  @override
  Future<List<ShoppingItemEntity>> fetchAll() async {
    final result = await couchbaseService.fetch(
      collectionName: collectionName,
      // filter: 'isCompleted = true',
    );

    final data = result.map(ShoppingItemEntity.fromMap).toList();
    return data;
  }

  @override
  Future<void> addItem(ShoppingItemEntity item) async {
    await couchbaseService.add(
      data: item.toMap(),
      collectionName: collectionName,
    );
    print('item foi salvo com sucesso');
  }

  @override
  Future<void> updateItem({
    required String id,
    String? title,
    bool? isCompleted,
  }) async {
    await couchbaseService.edit(
      collectionName: collectionName,
      id: id,
      data: {
        if (title != null) 'title': title,
        if (isCompleted != null) 'isCompleted': isCompleted,
      },
    );
  }

  @override
  Future<void> deleteItem(String id) async {
    await couchbaseService.delete(
      collectionName: collectionName,
      id: id,
    );
  }
}
