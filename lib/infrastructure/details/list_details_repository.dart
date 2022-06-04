import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/details/list_details_interface.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: ListDetailsInterface)
class ListDetailsRepository implements ListDetailsInterface {
  @override
  Future<void> updateCheckStatus(String id, ListItem item) async {
    try {
      await http.patch(
        Uri.parse('$kBaseUrl/$id/$kItemsField/${item.id}$kJson'),
        body: await compute(_parseToJson, item),
      );
    } catch (e) {
      // Error would be logged on crashlytics
    }
  }

  @override
  void deleteItem(String listId, String itemId) async {
    try {
      http.delete(Uri.parse('$kBaseUrl/$listId/$kItemsField/$itemId$kJson'));
    } catch (_) {
      // Error would be logged on crashlytics
    }
  }

  String _parseToJson(ListItem item) {
    return jsonEncode(item.toJson());
  }
}
