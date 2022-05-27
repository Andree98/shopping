import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/entities/unit.dart';
import 'package:shopping/domain/repository_impl.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: RepositoryImpl)
class Repository implements RepositoryImpl {
  @override
  Future<Result<Exception, Unit>> createList(ShoppingList list) async {
    try {
      final result = await http.post(
        Uri.parse(kBaseUrl),
        body: list.toShoppingListDto().toJson(),
      );

      print(result);

      return const Success(unit);
    } on Exception catch (e) {
      // TODO handle error
      return Failure(e);
    }
  }
}
