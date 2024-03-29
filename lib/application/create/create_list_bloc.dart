import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/create/create_list_interface.dart';
import 'package:shopping/domain/create/entities/list_title.dart';
import 'package:uuid/uuid.dart';

part 'create_list_bloc.freezed.dart';
part 'create_list_event.dart';
part 'create_list_state.dart';

@injectable
class CreateListBloc extends Bloc<CreateListEvent, CreateListState> {
  final CreateListInterface _createListInterface;

  CreateListBloc(this._createListInterface) : super(CreateListState.initial()) {
    on<CreateListEvent>(
      (event, emit) async => event.map(
        titleChanged: (e) => _onTitleChangedEvent(e.input, emit),
        addItem: (e) => _onAddItemEvent(e.item, emit),
        removeItem: (e) => _onRemoveItemEvent(e.index, emit),
        checkStateChanged: (e) =>
            _onCheckStateChangedEvent(e.index, e.isChecked, emit),
        saveList: (_) async => _onSaveListEvent(emit),
      ),
    );
  }

  void _onTitleChangedEvent(String input, Emitter<CreateListState> emit) {
    emit(state.copyWith(title: ListTitle(input.trim())));
  }

  void _onAddItemEvent(ListItem item, Emitter<CreateListState> emit) {
    emit(state.copyWith(items: List.from(state.items)..add(item)));
  }

  void _onRemoveItemEvent(int index, Emitter<CreateListState> emit) {
    emit(state.copyWith(items: List.from(state.items)..removeAt(index)));
  }

  void _onCheckStateChangedEvent(
    int index,
    bool isChecked,
    Emitter<CreateListState> emit,
  ) {
    final updatedItem = state.items[index].copyWith(isChecked: isChecked);

    final updatedList = List<ListItem>.from(state.items)
      ..removeAt(index)
      ..insert(index, updatedItem);

    emit(state.copyWith(items: updatedList));
  }

  Future<void> _onSaveListEvent(Emitter<CreateListState> emit) async {
    Result? saveListResult;
    ShoppingList? shoppingList;

    if (state.title.isValid()) {
      emit(
        state.copyWith(
          isSaving: true,
          saveListResult: null,
          createdList: null,
        ),
      );

      shoppingList = ShoppingList(
        id: const Uuid().v1(),
        title: state.title.get(),
        created: DateTime.now().millisecondsSinceEpoch,
        items: state.items,
      );

      saveListResult = await _createListInterface.createList(shoppingList);
    }

    emit(
      state.copyWith(
        isSaving: false,
        showError: true,
        saveListResult: saveListResult,
        createdList: shoppingList,
      ),
    );
  }
}
