import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/details/list_details_interface.dart';

part 'list_details_bloc.freezed.dart';
part 'list_details_event.dart';
part 'list_details_state.dart';

@injectable
class ListDetailsBloc extends Bloc<ListDetailsEvent, ListDetailsState> {
  final ListDetailsInterface _interface;

  ListDetailsBloc(this._interface) : super(ListDetailsState.initial()) {
    on<ListDetailsEvent>(
      (event, emit) => event.map(
        setItems: (e) => emit(state.copyWith(items: e.items)),
        deleteItem: (e) => _onDeleteItemEvent(e.listId, e.itemId, emit),
        checkStatusChanged: (e) =>
            _onCheckStateChangedEvent(e.id, e.index, e.isChecked, emit),
      ),
    );
  }

  void _onCheckStateChangedEvent(
    String id,
    int index,
    bool isChecked,
    Emitter<ListDetailsState> emit,
  ) {
    final updatedItem = state.items[index].copyWith(isChecked: isChecked);

    _interface.updateCheckStatus(id, updatedItem);

    final updatedList = List<ListItem>.from(state.items)
      ..removeAt(index)
      ..insert(index, updatedItem);

    emit(state.copyWith(items: updatedList));
  }

  void _onDeleteItemEvent(
    String listId,
    String itemId,
    Emitter<ListDetailsState> emit,
  ) {
    _interface.deleteItem(listId, itemId);

    final updatedList = List<ListItem>.from(state.items)
      ..removeWhere((e) => e.id == itemId);

    emit(state.copyWith(items: updatedList));
  }
}
