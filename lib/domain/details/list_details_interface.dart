import 'package:shopping/domain/common/entities/list_item.dart';

abstract class ListDetailsInterface {
  /// There functions return void to simulate a real time experience without
  /// waiting for the backend response. Ideally I would work with a local cache
  /// and keep is in sync with backend but since this is a simple app that won't
  /// be needed

  Future<void> updateCheckStatus(String id, ListItem items);

  void deleteItem(String listId, String itemId);
}
