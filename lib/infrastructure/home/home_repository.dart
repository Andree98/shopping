import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/shopping_list_dto.dart';
import 'package:shopping/domain/common/entities/unit.dart';
import 'package:shopping/domain/home/home_interface.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: HomeInterface)
class HomeRepository implements HomeInterface {
  final Client _client;

  const HomeRepository({
    required Client client,
  }) : _client = client;

  @override
  Future<Result<int, Unit>> deleteList(String id) async {
    try {
      final response = await _client.delete(Uri.parse('$kBaseUrl/$id$kJson'));

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        return Failure(response.statusCode);
      }
    } catch (_) {
      return const Failure(kClientError);
    }
  }

  @override
  Future<Result<int, Unit>> deleteAllLists() async {
    try {
      final response = await _client.delete(Uri.parse('$kBaseUrl/$kJson'));

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        return Failure(response.statusCode);
      }
    } catch (_) {
      return const Failure(kClientError);
    }
  }

  @override
  Future<Result<int, List<ShoppingList>>> getAllLists() async {
    try {
      final response = await _client.get(Uri.parse('$kBaseUrl/$kJson'));

      if (response.statusCode == HttpStatus.ok) {
        return Success(await compute(_parseFromJson, response.body));
      } else {
        return Failure(response.statusCode);
      }
    } catch (e) {
      return const Failure(kClientError);
    }
  }
}

List<ShoppingList> _parseFromJson(String body) {
  /// when there is no data in the database, it returns the text "null"
  /// if that happens we should return an empty list so the jsonDecode doesn't
  /// fall on the catch block, that would cause an error to be displayed.

  if (body == 'null') return [];

  return (jsonDecode(body) as Map<String, dynamic>)
      .entries
      .map((e) => ShoppingListDto.fromJson(e.value).toShoppingList())
      .toList();
}
