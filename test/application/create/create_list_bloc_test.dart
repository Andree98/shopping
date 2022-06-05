import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/create/entities/list_title.dart';
import 'package:test/test.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  late MockCreateListInterface createListInterface;
  late List<ListItem> listItems;

  setUp(() {
    createListInterface = MockCreateListInterface();
    listItems = List.generate(5, (_) => createListItem());
  });

  blocTest(
    'Should emit a new title state when a titleChanged event is received',
    build: () => CreateListBloc(createListInterface),
    act: (CreateListBloc bloc) async => bloc.add(
      const CreateListEvent.titleChanged('title   '),
    ),
    expect: () => [
      CreateListState.initial().copyWith(title: ListTitle('title')),
    ],
  );

  final newItem = createListItem();

  blocTest(
    'Should emit a new list with the added item when a addItem event is received',
    seed: () => CreateListState.initial().copyWith(items: listItems),
    build: () => CreateListBloc(createListInterface),
    act: (CreateListBloc bloc) async => bloc.add(
      CreateListEvent.addItem(newItem),
    ),
    expect: () => [
      CreateListState.initial().copyWith(items: listItems..add(newItem)),
    ],
  );

  late int index;

  blocTest(
    'Should emit a new list without the removed item when a removeItem event is received',
    setUp: () {
      index = Random().nextInt(listItems.length);
    },
    seed: () => CreateListState.initial().copyWith(items: listItems),
    build: () => CreateListBloc(createListInterface),
    act: (CreateListBloc bloc) async => bloc.add(
      CreateListEvent.removeItem(index),
    ),
    expect: () => [
      CreateListState.initial().copyWith(items: listItems..removeAt(index)),
    ],
  );

  late ListItem updatedItem;
  blocTest(
    'Should emit an updated items list when a checkStateChanged event is received',
    setUp: () {
      index = Random().nextInt(listItems.length);
      updatedItem = listItems[index];
    },
    seed: () => CreateListState.initial().copyWith(items: listItems),
    build: () => CreateListBloc(createListInterface),
    act: (CreateListBloc bloc) async => bloc.add(
      CreateListEvent.checkStateChanged(index, !updatedItem.isChecked),
    ),
    expect: () => [
      CreateListState.initial().copyWith(
        items: listItems
          ..removeAt(index)
          ..insert(
            index,
            updatedItem.copyWith(isChecked: !updatedItem.isChecked),
          ),
      ),
    ],
  );

  group('saveListEvent', () {
    blocTest('Should not call the interface when the title is not valid',
        seed: () => CreateListState.initial().copyWith(items: listItems),
        build: () => CreateListBloc(createListInterface),
        act: (CreateListBloc bloc) async => bloc.add(
              const CreateListEvent.saveList(),
            ),
        expect: () => [
              CreateListState.initial()
                  .copyWith(showError: true, items: listItems),
            ],
        verify: (_) => verifyZeroInteractions(createListInterface));
  });
}
