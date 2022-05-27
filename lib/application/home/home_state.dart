part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required List<ShoppingList> shoppingLists,
  }) = _HomeState;

  factory HomeState.initial() => const HomeState(shoppingLists: []);
}
