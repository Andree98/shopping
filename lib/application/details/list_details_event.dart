part of 'list_details_bloc.dart';

@freezed
class ListDetailsEvent with _$ListDetailsEvent {
  const factory ListDetailsEvent.loadShoppingList(String listId) = _LoadList;

  const factory ListDetailsEvent.addItem(ListItem item) = _AddItem;

  const factory ListDetailsEvent.deleteItem(String itemId) = _DeleteItem;

  const factory ListDetailsEvent.checkStatusChanged(
    int index,
    bool isChecked,
  ) = _CheckStatusChanged;
}
