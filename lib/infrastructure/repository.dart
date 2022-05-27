import 'dart:convert';
import 'dart:io';

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
  Future<Result<int, Unit>> createList(ShoppingList list) async {
    try {
      final response = await http.post(
        Uri.parse(kBaseUrl),
        body: jsonEncode(list.toShoppingListDto().toJson()),
      );

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        // Log in crashlytics
        return Failure(response.statusCode);
      }
    } on Exception catch (_) {
      // Here I would record the error in Firebase Crashlytics
      return const Failure(HttpStatus.serviceUnavailable);
    }
  }
}
