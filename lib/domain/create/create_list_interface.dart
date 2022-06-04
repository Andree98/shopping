import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/unit.dart';

abstract class CreateListInterface {
  Future<Result<int, Unit>> createList(ShoppingList list);
}
