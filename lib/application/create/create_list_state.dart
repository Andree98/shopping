part of 'create_list_bloc.dart';

@freezed
class CreateListState with _$CreateListState {
  const factory CreateListState({
    required ListTitle title,
    required bool showError,
  }) = _CreateListState;

  factory CreateListState.initial() => CreateListState(
        title: ListTitle(''),
        showError: true,
      );
}
