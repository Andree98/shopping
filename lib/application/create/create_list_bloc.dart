import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shopping/domain/create/create_list_interface.dart';
import 'package:shopping/domain/entities/list_item.dart';
import 'package:shopping/domain/entities/title.dart';

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
        addItem: (e) => _onAddItemEvent(e.label, emit),
        removeItem: (e) => _onRemoveItemEvent(e.index, emit),
        checkStateChanged: (e) =>
            _onCheckStateChangedEvent(e.index, e.isChecked, emit),
      ),
    );
  }

  void _onTitleChangedEvent(String input, Emitter<CreateListState> emit) {
    emit(state.copyWith(title: ListTitle(input.trim())));
  }

  void _onAddItemEvent(String label, Emitter<CreateListState> emit) {
    final listItem = ListItem(label: label, isChecked: false);
    emit(state.copyWith(items: List.from(state.items)..add(listItem)));
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
}
