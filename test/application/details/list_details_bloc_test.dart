import 'dart:io';
import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  late MockListDetailsInterface listDetailsInterface;
  final shoppingList = createShoppingList();

  setUp(() {
    listDetailsInterface = MockListDetailsInterface();
  });

  blocTest(
    'Should call the interface and emit the received shopping list when getShoppingList() result is a Success',
    setUp: () {
      when(() => listDetailsInterface.getShoppingList(shoppingList.id))
          .thenAnswer((_) async => Success(shoppingList));
    },
    build: () => ListDetailsBloc(listDetailsInterface),
    act: (ListDetailsBloc bloc) async => bloc.add(
      ListDetailsEvent.loadShoppingList(shoppingList.id),
    ),
    expect: () => [
      ListDetailsState.initial().copyWith(
        isLoading: false,
        shoppingList: shoppingList,
        loadListResult: Success(shoppingList),
      ),
    ],
    verify: (_) {
      verify(() => listDetailsInterface.getShoppingList(shoppingList.id));
    },
  );

  const statusCode = HttpStatus.notFound;

  blocTest(
    'Should call the interface and emit the a null shopping list when getShoppingList() result is a Failure',
    setUp: () {
      when(() => listDetailsInterface.getShoppingList(shoppingList.id))
          .thenAnswer((_) async => const Failure(statusCode));
    },
    build: () => ListDetailsBloc(listDetailsInterface),
    act: (ListDetailsBloc bloc) async => bloc.add(
      ListDetailsEvent.loadShoppingList(shoppingList.id),
    ),
    expect: () => [
      ListDetailsState.initial().copyWith(
        isLoading: false,
        shoppingList: null,
        loadListResult: const Failure(statusCode),
      ),
    ],
    verify: (_) {
      verify(() => listDetailsInterface.getShoppingList(shoppingList.id));
    },
  );

  final newItem = createListItem();

  blocTest(
    'Should emit a new list with the added item and call the interface when a addItem event is received',
    setUp: () {
      when(() => listDetailsInterface.addItem(shoppingList.id, newItem))
          .thenAnswer((_) async => {});
    },
    build: () => ListDetailsBloc(listDetailsInterface),
    seed: () => ListDetailsState.initial().copyWith(shoppingList: shoppingList),
    act: (ListDetailsBloc bloc) async => bloc.add(
      ListDetailsEvent.addItem(newItem),
    ),
    expect: () => [
      ListDetailsState.initial().copyWith(
        shoppingList: shoppingList.copyWith(
          items: List.from(shoppingList.items)..add(newItem),
        ),
      ),
    ],
    verify: (_) {
      verify(() => listDetailsInterface.addItem(shoppingList.id, newItem));
    },
  );

  final removedItem = shoppingList.items.last;

  blocTest(
    'Should emit a new list without the removed item and call the interface when a removeItem event is received',
    build: () => ListDetailsBloc(listDetailsInterface),
    seed: () => ListDetailsState.initial().copyWith(shoppingList: shoppingList),
    act: (ListDetailsBloc bloc) async => bloc.add(
      ListDetailsEvent.deleteItem(removedItem.id),
    ),
    expect: () => [
      ListDetailsState.initial().copyWith(
        shoppingList: shoppingList.copyWith(
          items: List.from(shoppingList.items)
            ..removeWhere((e) => e.id == removedItem.id),
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => listDetailsInterface.deleteItem(shoppingList.id, removedItem.id),
      );
    },
  );

  late int index;
  late ListItem updatedItem;
  blocTest(
    'Should emit an updated items list and call the interface when a checkStateChanged event is received',
    setUp: () {
      index = Random().nextInt(shoppingList.items.length);
      updatedItem = shoppingList.items[index];

      when(() => listDetailsInterface.updateCheckStatus(
            shoppingList.id,
            updatedItem.copyWith(isChecked: !updatedItem.isChecked),
          )).thenAnswer((_) async => {});
    },
    build: () => ListDetailsBloc(listDetailsInterface),
    seed: () => ListDetailsState.initial().copyWith(shoppingList: shoppingList),
    act: (ListDetailsBloc bloc) async => bloc.add(
      ListDetailsEvent.checkStatusChanged(index, !updatedItem.isChecked),
    ),
    expect: () => [
      ListDetailsState.initial().copyWith(
        shoppingList: shoppingList.copyWith(
          items: List.from(shoppingList.items)
            ..removeAt(index)
            ..insert(
              index,
              updatedItem.copyWith(isChecked: !updatedItem.isChecked),
            ),
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => listDetailsInterface.updateCheckStatus(
          shoppingList.id,
          updatedItem.copyWith(isChecked: !updatedItem.isChecked),
        ),
      );
    },
  );
}
