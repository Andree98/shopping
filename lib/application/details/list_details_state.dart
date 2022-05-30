part of 'list_details_bloc.dart';

@freezed
class ListDetailsState with _$ListDetailsState {
  const factory ListDetailsState({
    required List<ListItem> items,
  }) = _ListDetailsState;

  factory ListDetailsState.initial() => const ListDetailsState(
        items: [],
      );
}
