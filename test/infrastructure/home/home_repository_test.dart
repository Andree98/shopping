import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/shopping_list_dto.dart';
import 'package:shopping/domain/common/entities/unit.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/data/constants.dart';
import 'package:shopping/infrastructure/home/home_repository.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  late HomeRepository repository;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    repository = HomeRepository(client: mockClient);
  });

  group('getAllLists', () {
    final baseUrl = Uri.parse('$kBaseUrl/$kJson');

    List<ShoppingList> parseFromJson(String body) {
      return (jsonDecode(body) as Map<String, dynamic>)
          .entries
          .map((e) => ShoppingListDto.fromJson(e.value).toShoppingList())
          .toList();
    }

    test(
      'Should return a success result with the decoded shopping list when the status code is ok',
      () async {
        // Arrange
        final response = Response(
          jsonEncode({'1': createShoppingList().toShoppingListDto().toJson()}),
          HttpStatus.ok,
        );

        when(() => mockClient.get(baseUrl)).thenAnswer((_) async => response);

        // Act
        final result = await repository.getAllLists();

        // Assert
        final decodedResponse = parseFromJson(response.body);

        expect(result.getSuccess(), decodedResponse);
        verify(() => mockClient.get(baseUrl));
      },
    );

    test(
      'Should return a success result with an empty list when the response body contains null',
      () async {
        // Arrange
        final response = Response('null', HttpStatus.ok);

        when(() => mockClient.get(baseUrl)).thenAnswer((_) async => response);

        // Act
        final result = await repository.getAllLists();

        // Assert
        expect(result.getSuccess(), []);
        verify(() => mockClient.get(baseUrl));
      },
    );

    test(
      'Should return a failure with the status code when the status code is not ok',
      () async {
        // Arrange
        const statusCode = HttpStatus.notFound;
        final response = Response('', statusCode);

        when(() => mockClient.get(baseUrl)).thenAnswer((_) async => response);

        // Act
        final result = await repository.getAllLists();

        // Assert
        expect(result, const Failure(statusCode));
        verify(() => mockClient.get(baseUrl));
      },
    );

    test(
      'Should return a failure with a custom status code when an exception is thrown',
      () async {
        // Arrange
        when(() => mockClient.get(baseUrl)).thenThrow(const HttpException(''));

        // Act
        final result = await repository.getAllLists();

        // Assert
        expect(result, const Failure(kClientError));
        verify(() => mockClient.get(baseUrl));
      },
    );
  });

  group('deleteAllLists', () {
    final baseUrl = Uri.parse('$kBaseUrl/$kJson');

    test(
      'Should return a success result when the status code is ok',
      () async {
        // Arrange
        final response = Response('', HttpStatus.ok);

        when(() => mockClient.delete(baseUrl))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.deleteAllLists();

        // Assert
        expect(result, const Success(unit));
        verify(() => mockClient.delete(baseUrl));
      },
    );

    test(
      'Should return a failure result with the status code when the status code is not ok',
      () async {
        // Arrange
        const statusCode = HttpStatus.unauthorized;
        final response = Response('', statusCode);

        when(() => mockClient.delete(baseUrl))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.deleteAllLists();

        // Assert
        expect(result, const Failure(statusCode));
        verify(() => mockClient.delete(baseUrl));
      },
    );

    test(
      'Should return a failure result with a custom status code when an exception is thrown',
      () async {
        // Arrange
        when(() => mockClient.delete(baseUrl))
            .thenThrow(const HttpException(''));

        // Act
        final result = await repository.deleteAllLists();

        // Assert
        expect(result, const Failure(kClientError));
        verify(() => mockClient.delete(baseUrl));
      },
    );
  });

  group('deleteList', () {
    final listId = createShoppingList().id;
    final baseUrl = Uri.parse('$kBaseUrl/$listId$kJson');

    test(
      'Should return a success result when the status code is ok',
      () async {
        // Arrange
        final response = Response('', HttpStatus.ok);

        when(() => mockClient.delete(baseUrl))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.deleteList(listId);

        // Assert
        expect(result, const Success(unit));
        verify(() => mockClient.delete(baseUrl));
      },
    );

    test(
      'Should return a failure result with the status code when the status code is not ok',
      () async {
        // Arrange
        const statusCode = HttpStatus.unauthorized;
        final response = Response('', statusCode);

        when(() => mockClient.delete(baseUrl))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.deleteList(listId);

        // Assert
        expect(result, const Failure(statusCode));
        verify(() => mockClient.delete(baseUrl));
      },
    );

    test(
      'Should return a failure result with a custom status code when an exception is thrown',
      () async {
        // Arrange
        when(() => mockClient.delete(baseUrl))
            .thenThrow(const HttpException(''));

        // Act
        final result = await repository.deleteList(listId);

        // Assert
        expect(result, const Failure(kClientError));
        verify(() => mockClient.delete(baseUrl));
      },
    );
  });
}
