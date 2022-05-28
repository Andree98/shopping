import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/repository_impl.dart';
import 'package:uuid/uuid.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final RepositoryImpl _repositoryImpl;

  HomeCubit(this._repositoryImpl) : super(HomeState.initial());

  void test() => _repositoryImpl.createList(ShoppingList(
      id: const Uuid().v4(),
      title: 'Test list 1',
      created: DateTime.now().millisecondsSinceEpoch,
      items: {'item 1': false}));

  Future<void> loadShoppingLists() async {
    final getResult = await _repositoryImpl.getAllLists();

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
    final deleteResult = await _repositoryImpl.deleteList(id);

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
    emit(state.copyWith(isDeleting: true));

    final shoppingList = List<ShoppingList>.from(state.shoppingLists);
    final deleteResult = await _repositoryImpl.deleteAllLists();

    if (deleteResult.isSuccess()) shoppingList.clear();

    emit(
      state.copyWith(
        isDeleting: false,
        shoppingLists: shoppingList,
        deleteListResult: deleteResult,
      ),
    );
  }

  void refresh() {
    emit(state.copyWith(isRefreshing: true));
    loadShoppingLists();
  }
}
