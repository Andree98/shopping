import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/home/home_interface.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

// This could be a bloc but I wanted to show I can also work with cubits

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeInterface _homeInterface;

  HomeCubit(this._homeInterface) : super(HomeState.initial());

  Future<void> loadShoppingLists() async {
    final getResult = await _homeInterface.getAllLists();

    emit(
      state.copyWith(
        isLoading: false,
        isRefreshing: false,
        shoppingLists: getResult.getSuccess() ?? [],
        getListsResult: getResult,
      ),
    );
  }

  Future<bool> removeShoppingList(String id) async {
    emit(state.copyWith(isDeleting: true, deleteListResult: null));

    final shoppingList = List<ShoppingList>.from(state.shoppingLists);
    final deleteResult = await _homeInterface.deleteList(id);

    if (deleteResult.isSuccess()) shoppingList.removeWhere((e) => e.id == id);

    emit(
      state.copyWith(
        isDeleting: false,
        shoppingLists: shoppingList,
        deleteListResult: deleteResult,
      ),
    );

    return deleteResult.isSuccess();
  }

  void removeAllLists() async {
    emit(state.copyWith(isDeleting: true, deleteListResult: null));

    final shoppingList = List<ShoppingList>.from(state.shoppingLists);
    final deleteResult = await _homeInterface.deleteAllLists();

    if (deleteResult.isSuccess()) shoppingList.clear();

    emit(
      state.copyWith(
        isDeleting: false,
        shoppingLists: shoppingList,
        deleteListResult: deleteResult,
      ),
    );
  }

  void updateShoppingList(ShoppingList list) {
    print(list);
    final index = state.shoppingLists.indexWhere((e) => e.id == list.id);

    final updatedList = List<ShoppingList>.from(state.shoppingLists)
      ..removeAt(index)
      ..insert(index, list);

    print(updatedList);

    emit(state.copyWith(shoppingLists: updatedList));
  }

  void addShoppingList(ShoppingList list) {
    final updatedList = List<ShoppingList>.from(state.shoppingLists)..add(list);

    emit(state.copyWith(shoppingLists: updatedList));
  }

  void refresh() {
    emit(state.copyWith(isRefreshing: true));

    loadShoppingLists();
  }
}
