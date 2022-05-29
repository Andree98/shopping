part of 'create_list_bloc.dart';

@freezed
class CreateListEvent with _$CreateListEvent {
  const factory CreateListEvent.titleChanged(String input) = _TitleChanged;

  const factory CreateListEvent.newItem(String label) = _NewItem;
}
