import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/unit.dart';
import 'package:shopping/domain/create/create_list_interface.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: CreateListInterface)
class CreateListRepository implements CreateListInterface {
  @override
  Future<Result<int, Unit>> createList(ShoppingList list) async {
    try {
      final response = await http.put(
        Uri.parse('$kBaseUrl/${list.id}$kJson'),
        body: await compute(_parseToJson, list),
      );

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        return Failure(response.statusCode);
      }
    } catch (e) {
      // Here I would record the error in Firebase Crashlytics
      return const Failure(kClientError);
    }
  }

  String _parseToJson(ShoppingList list) {
    return jsonEncode(list.toShoppingListDto().toJson());
  }
}
