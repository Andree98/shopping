part of 'create_list_bloc.dart';

@freezed
class CreateListState with _$CreateListState {
  const factory CreateListState({
    required ListTitle title,
    required bool isSaving,
    required bool showError,
    required List<ListItem> items,
    Result? saveListResult,
  }) = _CreateListState;

  factory CreateListState.initial() => CreateListState(
        title: ListTitle(''),
        isSaving: false,
        showError: false,
        items: [],
      );
}
