import 'dart:io';
import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/unit.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  const statusCode = HttpStatus.unauthorized;
  late MockHomeInterface homeInterface;
  late List<ShoppingList> shoppingLists;

  setUp(() {
    homeInterface = MockHomeInterface();
    shoppingLists = List.generate(5, (index) => createShoppingList());
  });

  group('loadShoppingLists', () {
    const statusCode = HttpStatus.unauthorized;

    blocTest(
      'Should emit a list of shopping lists when getAllLists returns a Success result',
      setUp: () {
        when(() => homeInterface.getAllLists())
            .thenAnswer((_) async => Success(shoppingLists));
      },
      build: () => HomeCubit(homeInterface),
      act: (HomeCubit cubit) async => cubit.loadShoppingLists(),
      expect: () => [
        HomeState.initial().copyWith(
          isLoading: false,
          isRefreshing: false,
          shoppingLists: shoppingLists,
          getListsResult: Success(shoppingLists),
        )
      ],
      verify: (_) {
        verify(() => homeInterface.getAllLists());
      },
    );

    blocTest(
      'Should emit an empty list when getAllLists returns a Failure result',
      setUp: () {
        when(() => homeInterface.getAllLists())
            .thenAnswer((_) async => const Failure(statusCode));
      },
      build: () => HomeCubit(homeInterface),
      act: (HomeCubit cubit) async => cubit.loadShoppingLists(),
      expect: () => [
        HomeState.initial().copyWith(
          isLoading: false,
          isRefreshing: false,
          shoppingLists: [],
          getListsResult: const Failure(statusCode),
        )
      ],
      verify: (_) {
        verify(() => homeInterface.getAllLists());
      },
    );
  });

  group('removeShoppingList', () {
    late ShoppingList deletedList;

    blocTest(
      'Should emit a new list without the deleted shopping list when deleteList returns a Success result',
      setUp: () {
        deletedList = shoppingLists[Random().nextInt(shoppingLists.length)];

        when(() => homeInterface.deleteList(deletedList.id))
            .thenAnswer((_) async => const Success(unit));
      },
      seed: () => HomeState.initial().copyWith(
        isLoading: false,
        shoppingLists: shoppingLists,
        deleteListResult: const Failure(HttpStatus.notFound),
      ),
      build: () => HomeCubit(homeInterface),
      act: (HomeCubit cubit) async => cubit.removeShoppingList(deletedList.id),
      expect: () => [
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: true,
          shoppingLists: shoppingLists,
          deleteListResult: null,
        ),
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: false,
          shoppingLists: shoppingLists
            ..removeWhere((e) => e.id == deletedList.id),
          deleteListResult: const Success(unit),
        ),
      ],
      verify: (_) {
        verify(() => homeInterface.deleteList(deletedList.id));
      },
    );

    blocTest(
      'Should emit the same list of shopping lists when deleteList returns a Failure result',
      setUp: () {
        when(() => homeInterface.deleteList(deletedList.id))
            .thenAnswer((_) async => const Failure(statusCode));
      },
      seed: () => HomeState.initial().copyWith(
        isLoading: false,
        shoppingLists: shoppingLists,
        deleteListResult: const Failure(HttpStatus.notFound),
      ),
      build: () => HomeCubit(homeInterface),
      act: (HomeCubit cubit) async => cubit.removeShoppingList(deletedList.id),
      expect: () => [
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: true,
          shoppingLists: shoppingLists,
          deleteListResult: null,
        ),
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: false,
          shoppingLists: shoppingLists,
          deleteListResult: const Failure(statusCode),
        ),
      ],
      verify: (_) {
        verify(() => homeInterface.deleteList(deletedList.id));
      },
    );
  });

  group('removeAllLists', () {
    blocTest(
      'Should emit an empty list of shopping lists when removeAllLists returns a Success result',
      setUp: () {
        when(() => homeInterface.deleteAllLists())
            .thenAnswer((_) async => const Success(unit));
      },
      seed: () => HomeState.initial().copyWith(
        isLoading: false,
        shoppingLists: shoppingLists,
        deleteListResult: const Failure(HttpStatus.notFound),
      ),
      build: () => HomeCubit(homeInterface),
      act: (HomeCubit cubit) async => cubit.removeAllLists(),
      expect: () => [
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: true,
          shoppingLists: shoppingLists,
          deleteListResult: null,
        ),
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: false,
          shoppingLists: [],
          deleteListResult: const Success(unit),
        ),
      ],
      verify: (_) {
        verify(() => homeInterface.deleteAllLists());
      },
    );

    blocTest(
      'Should emit the same list of shopping lists when removeAllLists returns a Failure result',
      setUp: () {
        when(() => homeInterface.deleteAllLists())
            .thenAnswer((_) async => const Failure(statusCode));
      },
      seed: () => HomeState.initial().copyWith(
        isLoading: false,
        shoppingLists: shoppingLists,
        deleteListResult: const Failure(HttpStatus.notFound),
      ),
      build: () => HomeCubit(homeInterface),
      act: (HomeCubit cubit) async => cubit.removeAllLists(),
      expect: () => [
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: true,
          shoppingLists: shoppingLists,
          deleteListResult: null,
        ),
        HomeState.initial().copyWith(
          isLoading: false,
          isDeleting: false,
          shoppingLists: shoppingLists,
          deleteListResult: const Failure(statusCode),
        ),
      ],
      verify: (_) {
        verify(() => homeInterface.deleteAllLists());
      },
    );
  });

  blocTest(
    'Should emit a isRefreshing state and load shopping lists when refresh() is called',
    setUp: () {
      when(() => homeInterface.getAllLists())
          .thenAnswer((_) async => Success(shoppingLists));
    },
    build: () => HomeCubit(homeInterface),
    act: (HomeCubit cubit) async => cubit.refresh(),
    expect: () => [
      HomeState.initial().copyWith(isRefreshing: true),
      HomeState.initial().copyWith(
        isLoading: false,
        isRefreshing: false,
        shoppingLists: shoppingLists,
        getListsResult: Success(shoppingLists),
      )
    ],
    verify: (_) {
      verify(() => homeInterface.getAllLists());
    },
  );

  final newList = createShoppingList();
  blocTest(
    'Should emit a new list with the added shopping list when addShoppingList() is called',
    seed: () => HomeState.initial().copyWith(shoppingLists: shoppingLists),
    build: () => HomeCubit(homeInterface),
    act: (HomeCubit cubit) async => cubit.addShoppingList(newList),
    expect: () => [
      HomeState.initial().copyWith(shoppingLists: shoppingLists..add(newList))
    ],
  );

  late int index;
  late ShoppingList updatedList;

  blocTest(
    'Should emit a new list with the selected list replaced when updateShoppingList() is called',
    setUp: () {
      index = Random().nextInt(shoppingLists.length);
      updatedList = shoppingLists[index].copyWith(title: 'new title');
    },
    seed: () => HomeState.initial().copyWith(shoppingLists: shoppingLists),
    build: () => HomeCubit(homeInterface),
    act: (HomeCubit cubit) async => cubit.updateShoppingList(updatedList),
    expect: () => [
      HomeState.initial().copyWith(
        shoppingLists: shoppingLists
          ..removeAt(index)
          ..insert(index, updatedList),
      )
    ],
  );
}
