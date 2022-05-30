import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/details/list_details_interface.dart';
import 'package:shopping/domain/entities/list_item.dart';
import 'package:shopping/domain/entities/unit.dart';
import 'package:shopping/infrastructure/data/constants.dart';

@LazySingleton(as: ListDetailsInterface)
class ListDetailsRepository implements ListDetailsInterface {
  @override
  Future<Result<int, Unit>> updateCheckStatus(
      String id, List<ListItem> items) async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/$id/items/$kJson'),
        body: await compute(_parseToJson, items),
      );

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        return Failure(response.statusCode);
      }
    } catch (e) {
      return const Failure(HttpStatus.serviceUnavailable);
    }
  }

  String _parseToJson(List<ListItem> items) {
    return jsonEncode(
      Map.fromEntries(items.map((e) => MapEntry(e.label, e.isChecked))),
    );
  }
}
