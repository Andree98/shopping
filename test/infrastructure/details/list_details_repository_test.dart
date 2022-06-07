import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list_dto.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';
import 'package:shopping/infrastructure/details/list_details_repository.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  final list = createShoppingList();

  late MockHttpClient mockClient;
  late ListDetailsRepository repository;

  setUp(() {
    mockClient = MockHttpClient();
    repository = ListDetailsRepository(client: mockClient);
  });

  group('getShoppingList', () {
    final baseUrl = Uri.parse('$kBaseUrl/${list.id}$kJson');

    test(
      'Should return a success result with a shopping list when the status code is ok',
      () async {
        // Arrange
        final response = Response(
          jsonEncode(createShoppingList().toShoppingListDto().toJson()),
          HttpStatus.ok,
        );

        when(() => mockClient.get(baseUrl)).thenAnswer((_) async => response);

        // Act
        final result = await repository.getShoppingList(list.id);

        // Assert
        final decodedResponse = ShoppingListDto.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        ).toShoppingList();

        expect(result, Success(decodedResponse));
        verify(() => mockClient.get(baseUrl));
      },
    );

    test(
      'Should return a failure result with the status code when the status code is not ok',
      () async {
        // Arrange
        const statusCode = HttpStatus.unauthorized;

        final response = Response(
          jsonEncode(createShoppingList().toShoppingListDto().toJson()),
          statusCode,
        );

        when(() => mockClient.get(baseUrl)).thenAnswer((_) async => response);

        // Act
        final result = await repository.getShoppingList(list.id);

        // Assert
        expect(result, const Failure(statusCode));
        verify(() => mockClient.get(baseUrl));
      },
    );

    test(
      'Should return a failure result with a custom status code when an exception is thrown',
      () async {
        // Arrange
        when(() => mockClient.get(baseUrl)).thenThrow(const HttpException(''));

        // Act
        final result = await repository.getShoppingList(list.id);

        // Assert
        expect(result, const Failure(kClientError));
        verify(() => mockClient.get(baseUrl));
      },
    );
  });

  group('updateCheckStatus', () {
    final item = createListItem();

    final baseUrl = Uri.parse(
      '$kBaseUrl/${list.id}/$kItemsField/${item.id}$kJson',
    );

    test(
      'Should call the client to make a patch request',
      () async {
        // Arrange

        // Act
        await repository.updateCheckStatus(list.id, item);

        // Assert
        verify(
          () => mockClient.patch(baseUrl, body: jsonEncode(item.toJson())),
        );
      },
    );
  });

  group('addItem', () {
    final item = createListItem();

    final baseUrl = Uri.parse(
      '$kBaseUrl/${list.id}/$kItemsField/${item.id}$kJson',
    );

    test(
      'Should call the client to make a put request',
      () async {
        // Arrange

        // Act
        await repository.addItem(list.id, item);

        // Assert
        verify(
          () => mockClient.put(baseUrl, body: jsonEncode(item.toJson())),
        );
      },
    );
  });

  group('deleteItem', () {
    final item = createListItem();

    final baseUrl = Uri.parse(
      '$kBaseUrl/${list.id}/$kItemsField/${item.id}$kJson',
    );

    test(
      'Should call the client to make a delete request',
      () async {
        // Arrange

        // Act
        repository.deleteItem(list.id, item.id);

        // Assert
        verify(() => mockClient.delete(baseUrl));
      },
    );
  });
}
