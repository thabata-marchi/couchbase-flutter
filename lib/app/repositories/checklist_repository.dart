import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/repositories/checklist_api_repository.dart';
// import 'package:checklist/app/repositories/checklist_mock_repository.dart';
import 'package:checklist/app/services/couchbase_service.dart';

abstract class ChecklistRepository {
  Future<List<ShoppingItemEntity>> fetchAll();
  Future<void> addItem(ShoppingItemEntity item);
  Future<ShoppingItemEntity> updateItem({
    required String id,
    String? title,
    bool? isCompleted,
  });
  Future<void> deleteItem(String id);

  factory ChecklistRepository({required CouchbaseService couchbaseService}) {
    return ChecklistApiRepository(couchbaseService: couchbaseService);
    // return ChecklistMockRepository(couchbaseService: couchbaseService);
  }
}
