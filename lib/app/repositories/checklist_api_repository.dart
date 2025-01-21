import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:checklist/app/services/couchbase_service.dart';

class ChecklistApiRepository implements ChecklistRepository {
  final CouchbaseService couchbaseService;
  ChecklistApiRepository({required this.couchbaseService});

  final List<ShoppingItemEntity> _items = [];
  final collectionName = 'checklist';

  @override
  Future<List<ShoppingItemEntity>> fetchAll() async {
    final result = await couchbaseService.fetch(
      collenctionName: collectionName,
      // filter: 'isCompleted = true',
    );

    final data = result.map((e) => ShoppingItemEntity.fromMap(e)).toList();
    return data;
  }

  @override
  Future<void> addItem(ShoppingItemEntity item) async {
    await couchbaseService.add(
        data: item.toMap(), collectionName: collectionName);
    print('item foi salvo com sucesso');
  }

  @override
  Future<ShoppingItemEntity> updateItem({
    required String id,
    String? title,
    bool? isCompleted,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _items.indexWhere((item) => item.id != null && item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        title: title,
        isCompleted: isCompleted,
      );

      return _items[index];
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.removeWhere((item) => item.id == id);
  }
}
