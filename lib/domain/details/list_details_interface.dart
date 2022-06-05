import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';

abstract class ListDetailsInterface {
  Future<Result<int, ShoppingList>> getShoppingList(String listId);

  /// There functions return void to simulate a real time experience without
  /// waiting for the backend response. Ideally I would work with a local cache
  /// and keep is in sync with backend but since this is a simple app that won't
  /// be needed

  Future<void> updateCheckStatus(String id, ListItem items);

  Future<void> addItem(String listId, ListItem item);

  void deleteItem(String listId, String itemId);
}
