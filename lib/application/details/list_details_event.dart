part of 'list_details_bloc.dart';

@freezed
class ListDetailsEvent with _$ListDetailsEvent {
  const factory ListDetailsEvent.setItems(List<ListItem> items) = _SetItems;

  const factory ListDetailsEvent.addItem(
    String listId,
    String label,
  ) = _AddItem;

  const factory ListDetailsEvent.deleteItem(
    String listId,
    String itemId,
  ) = _DeleteItem;

  const factory ListDetailsEvent.checkStatusChanged(
    String id,
    int index,
    bool isChecked,
  ) = _CheckStatusChanged;
}
