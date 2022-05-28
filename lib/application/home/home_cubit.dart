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
      id: const Uuid().v1(),
      title: 'Test list 1',
      created: DateTime.now().millisecondsSinceEpoch,
      items: {'item 1': false}));

  Future<void> loadShoppingLists() async {
    final getResult = await _repositoryImpl.getAllShoppingLists();

    print(getResult.get());
    emit(
      state.copyWith(
        isLoading: false,
        shoppingLists: getResult.getSuccess() ?? [],
        getListsResult: getResult,
      ),
    );
  }

  Future<void> removeShoppingList(String id) async {
    emit(state.copyWith(isDeleting: true));

    final shoppingList = List<ShoppingList>.from(state.shoppingLists);
    final deleteResult = await _repositoryImpl.removeList(id);

    if (deleteResult.isSuccess()) shoppingList.removeWhere((e) => e.id == id);

    emit(
      state.copyWith(
        isLoading: false,
        shoppingLists: shoppingList,
        deleteListResult: deleteResult,
      ),
    );
  }
}
