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
  Future<Result<int, Unit>> updateCheckStatus(String id, ListItem item) async {
    try {
      final response = await http.patch(
        Uri.parse('$kBaseUrl/$id/$kItemsField/${item.id}$kJson'),
        body: await compute(_parseToJson, item),
      );

      if (response.statusCode == HttpStatus.ok) {
        return const Success(unit);
      } else {
        return Failure(response.statusCode);
      }
    } catch (e) {
      return const Failure(kClientError);
    }
  }

  String _parseToJson(ListItem item) {
    return jsonEncode(item.toJson());
  }
}
