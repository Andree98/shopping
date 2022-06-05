import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/unit.dart';
import 'package:shopping/domain/utils/mappers.dart';
import 'package:shopping/infrastructure/create/create_list_repository.dart';
import 'package:shopping/infrastructure/data/constants.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  late CreateListRepository repository;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    repository = CreateListRepository(client: mockClient);
  });

  group('createList', () {
    final list = createShoppingList();
    final baseUrl = Uri.parse('$kBaseUrl/${list.id}$kJson');
    final encodedBody = jsonEncode(list.toShoppingListDto().toJson());

    test(
      'Should return a success result when the status code is ok',
      () async {
        // Arrange
        final response = Response('', HttpStatus.ok);

        when(() => mockClient.put(baseUrl, body: encodedBody))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.createList(list);

        // Assert
        expect(result, const Success(unit));
        verify(() => mockClient.put(baseUrl, body: encodedBody));
      },
    );

    test(
      'Should return a failure result with the status code when the status code is not ok',
      () async {
        // Arrange
        const statusCode = HttpStatus.unauthorized;
        final response = Response('', statusCode);

        when(() => mockClient.put(baseUrl, body: encodedBody))
            .thenAnswer((_) async => response);

        // Act
        final result = await repository.createList(list);

        // Assert
        expect(result, const Failure(statusCode));
        verify(() => mockClient.put(baseUrl, body: encodedBody));
      },
    );

    test(
      'Should return a failure result with a custom status code when an exception is thrown',
      () async {
        // Arrange
        when(() => mockClient.put(baseUrl, body: encodedBody))
            .thenThrow(const HttpException(''));

        // Act
        final result = await repository.createList(list);

        // Assert
        expect(result, const Failure(kClientError));
        verify(() => mockClient.put(baseUrl, body: encodedBody));
      },
    );
  });
}
