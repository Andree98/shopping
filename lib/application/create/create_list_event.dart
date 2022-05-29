part of 'create_list_bloc.dart';

@freezed
class CreateListEvent with _$CreateListEvent {
  const factory CreateListEvent.titleChanged(String input) = _TitleChanged;

  const factory CreateListEvent.addItem(String label) = _AddItem;

  const factory CreateListEvent.removeItem(int index) = _RemoveItem;

  const factory CreateListEvent.checkStateChanged(
    int index,
    bool isChecked,
  ) = _CheckStateChanged;
}
