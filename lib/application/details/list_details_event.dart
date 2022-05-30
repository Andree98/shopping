part of 'list_details_bloc.dart';

@freezed
class ListDetailsEvent with _$ListDetailsEvent {
  const factory ListDetailsEvent.setItems(List<ListItem> items) = _SetItems;

  const factory ListDetailsEvent.checkStatusChanged(
    int index,
    bool isChecked,
  ) = _CheckStatusChanged;
}
