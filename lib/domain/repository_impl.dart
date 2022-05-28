import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/entities/unit.dart';

abstract class RepositoryImpl {
  Future<Result<int, Unit>> createList(ShoppingList list);

  Future<Result<int, Unit>> removeList(String id);

  Future<Result<int, List<ShoppingList>>> getAllShoppingLists();
}
