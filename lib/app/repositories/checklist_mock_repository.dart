import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:checklist/app/services/couchbase_service.dart';

class ChecklistMockRepository implements ChecklistRepository {
  final CouchbaseService couchbaseService;
  ChecklistMockRepository({required this.couchbaseService});

  final List<ShoppingItemEntity> _items = [];

  final collectionName = 'checklist';

  @override
  Future<List<ShoppingItemEntity>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List<ShoppingItemEntity>.from(_items);
  }

  @override
  Future<void> addItem(ShoppingItemEntity item) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.add(item.copyWith(id: '${_items.length + 1}'));
  }

  @override
  Future<void> updateItem({
    required String id,
    String? title,
    bool? isCompleted,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        title: title,
        isCompleted: isCompleted,
      );
    } else {
      throw Exception('Item not found');
    }
  }

  // @override
  // Future<ShoppingItemEntity> updateItem({
  //   required String id,
  //   String? title,
  //   bool? isCompleted,
  // }) async {
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   final index = _items.indexWhere((item) => item.id != null && item.id == id);
  //   if (index != -1) {
  //     _items[index] = _items[index].copyWith(
  //       title: title,
  //       isCompleted: isCompleted,
  //     );

  //     return _items[index];
  //   } else {
  //     throw Exception();
  //   }
  // }

  @override
  Future<void> deleteItem(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.removeWhere((item) => item.id == id);
  }
}
