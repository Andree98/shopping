import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/entities/list_item.dart';
import 'package:shopping/domain/entities/unit.dart';

abstract class ListDetailsInterface {
  Future<Result<int, Unit>> updateCheckStatus(String id, ListItem items);

  Future<Result<int, Unit>> deleteItem(String listId, String itemId);
}
