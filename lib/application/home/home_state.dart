part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required bool isLoading,
    required bool isDeleting,
    required bool isRefreshing,
    required List<ShoppingList> shoppingLists,
    Result? getListsResult,
    Result? deleteListResult,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState(
    isLoading: true,
        isDeleting: false,
        isRefreshing: false,
        shoppingLists: [],
      );
}
