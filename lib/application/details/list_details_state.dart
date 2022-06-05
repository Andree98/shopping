part of 'list_details_bloc.dart';

@freezed
class ListDetailsState with _$ListDetailsState {
  const factory ListDetailsState({
    required bool isLoading,
    ShoppingList? shoppingList,
    Result? loadListResult,
  }) = _ListDetailsState;

  factory ListDetailsState.initial() => const ListDetailsState(
    isLoading: true,
      );
}
