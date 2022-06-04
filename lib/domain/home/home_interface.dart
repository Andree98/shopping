import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/unit.dart';

abstract class HomeInterface {
  Future<Result<int, Unit>> deleteList(String id);

  Future<Result<int, Unit>> deleteAllLists();

  Future<Result<int, List<ShoppingList>>> getAllLists();
}
