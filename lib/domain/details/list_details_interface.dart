import 'package:shopping/domain/common/entities/list_item.dart';

abstract class ListDetailsInterface {
  Future<void> updateCheckStatus(String id, ListItem items);

  void deleteItem(String listId, String itemId);
}
