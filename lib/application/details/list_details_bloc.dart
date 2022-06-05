import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/details/list_details_interface.dart';
import 'package:uuid/uuid.dart';

part 'list_details_bloc.freezed.dart';
part 'list_details_event.dart';
part 'list_details_state.dart';

@injectable
class ListDetailsBloc extends Bloc<ListDetailsEvent, ListDetailsState> {
  final ListDetailsInterface _interface;

  ListDetailsBloc(this._interface) : super(ListDetailsState.initial()) {
    on<ListDetailsEvent>(
      (event, emit) async => event.map(
        loadShoppingList: (e) async => _onLoadShoppingListEvent(e.listId, emit),
        addItem: (e) => _onAddItemEvent(e.label, emit),
        deleteItem: (e) => _onDeleteItemEvent(e.itemId, emit),
        checkStatusChanged: (e) =>
            _onCheckStateChangedEvent(e.index, e.isChecked, emit),
      ),
    );
  }

  Future<void> _onLoadShoppingListEvent(
    String listId,
    Emitter<ListDetailsState> emit,
  ) async {
    final result = await _interface.getShoppingList(listId);

    emit(state.copyWith(
      isLoading: false,
      shoppingList: result.getSuccess(),
      loadListResult: result,
    ));
  }

  void _onCheckStateChangedEvent(
    int index,
    bool isChecked,
    Emitter<ListDetailsState> emit,
  ) {
    final list = state.shoppingList!;
    final updatedItem = list.items[index].copyWith(isChecked: isChecked);

    _interface.updateCheckStatus(state.shoppingList!.id, updatedItem);

    final updatedList = list.copyWith(
      items: List.from(list.items)
        ..removeAt(index)
        ..insert(index, updatedItem),
    );

    emit(state.copyWith(shoppingList: updatedList));
  }

  void _onAddItemEvent(String label, Emitter<ListDetailsState> emit) {
    final item = ListItem(
      id: const Uuid().v1(),
      label: label,
      isChecked: false,
    );

    final list = state.shoppingList!;

    _interface.addItem(list.id, item);

    final updatedList = list.copyWith(items: List.from(list.items)..add(item));

    emit(state.copyWith(shoppingList: updatedList));
  }

  void _onDeleteItemEvent(String itemId, Emitter<ListDetailsState> emit) {
    final list = state.shoppingList!;

    _interface.deleteItem(list.id, itemId);

    final updatedList = list.copyWith(
      items: List.from(list.items)..removeWhere((e) => e.id == itemId),
    );

    emit(state.copyWith(shoppingList: updatedList));
  }
}
