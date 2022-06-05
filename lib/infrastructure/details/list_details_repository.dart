import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/shopping_list_dto.dart';
import 'package:shopping/domain/details/list_details_interface.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: ListDetailsInterface)
class ListDetailsRepository implements ListDetailsInterface {
  final Client _client;

  const ListDetailsRepository({
    required Client client,
  }) : _client = client;

  @override
  Future<void> updateCheckStatus(String id, ListItem item) async {
    try {
      await _client.patch(
        Uri.parse('$kBaseUrl/$id/$kItemsField/${item.id}$kJson'),
        body: await compute(_parseToJson, item),
      );
    } catch (e) {
      // Error would be logged on crashlytics
    }
  }

  @override
  Future<void> addItem(String listId, ListItem item) async {
    try {
      _client.put(
        Uri.parse('$kBaseUrl/$listId/$kItemsField/${item.id}$kJson'),
        body: await compute(_parseToJson, item),
      );
    } catch (e) {
      // Error would be logged on crashlytics
    }
  }

  @override
  void deleteItem(String listId, String itemId) async {
    try {
      _client.delete(Uri.parse('$kBaseUrl/$listId/$kItemsField/$itemId$kJson'));
    } catch (_) {
      // Error would be logged on crashlytics
    }
  }

  @override
  Future<Result<int, ShoppingList>> getShoppingList(String listId) async {
    try {
      final response = await _client.get(Uri.parse('$kBaseUrl/$listId$kJson'));

      if (response.statusCode == HttpStatus.ok) {
        final shoppingList = await compute(_parseFromJson, response.body);

        if (shoppingList == null) return const Failure(HttpStatus.notFound);

        return Success(shoppingList);
      } else {
        return Failure(response.statusCode);
      }
    } catch (_) {
      return const Failure(kClientError);
    }
  }
}

ShoppingList? _parseFromJson(String body) {
  return ShoppingListDto.fromJson(jsonDecode(body) as Map<String, dynamic>)
      .toShoppingList();
}

String _parseToJson(ListItem item) {
  return jsonEncode(item.toJson());
}
