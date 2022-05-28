import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/entities/shopping_list_dto.dart';
import 'package:shopping/domain/entities/unit.dart';
import 'package:shopping/domain/repository_impl.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: RepositoryImpl)
class Repository implements RepositoryImpl {
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
    } catch (_) {
      // Here I would record the error in Firebase Crashlytics
      return const Failure(HttpStatus.serviceUnavailable);
    }
  }

  @override
  Future<Result<int, Unit>> removeList(String id) async {
    try {
      final response = await http.delete(Uri.parse('$kBaseUrl/$id$kJson'));

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        return Failure(response.statusCode);
      }
    } catch (_) {
      return const Failure(HttpStatus.serviceUnavailable);
    }
  }

  @override
  Future<Result<int, List<ShoppingList>>> getAllShoppingLists() async {
    try {
      final response = await http.get(Uri.parse('$kBaseUrl/$kJson'));

      if (response.statusCode == HttpStatus.ok) {
        return Success(await compute(_parseFromJson, response.body));
      } else {
        return Failure(response.statusCode);
      }
    } catch (e) {
      print(e);
      return const Failure(HttpStatus.serviceUnavailable);
    }
  }

  List<ShoppingList> _parseFromJson(String body) {
    /// when there is no data in the database, it returns the text "null"
    /// if that happens we should return an empty list so the jsonDecode doesn't
    /// fall on the catch block, that would cause an error to be displayed.

    if (body.contains('null')) return [];

    return (jsonDecode(body) as Map<String, dynamic>)
        .entries
        .map((e) => ShoppingListDto.fromJson(e.value).toShoppingList())
        .toList();
  }

  String _parseToJson(ShoppingList list) {
    return jsonEncode(list.toShoppingListDto().toJson());
  }
}
