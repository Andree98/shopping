import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/repository_impl.dart';
import 'package:uuid/uuid.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final RepositoryImpl _repositoryImpl;

  HomeCubit(this._repositoryImpl) : super(HomeState.initial());

  void createListTest() {
    final list = ShoppingList(
      id: const Uuid().v1(),
      title: 'Test list',
      items: {
        'Item 1': false,
        'Item 2': true,
      },
    );

    _repositoryImpl.createList(list);
  }

  Future<void> getListsTest() async {
    final result = await _repositoryImpl.getAllShoppingLists();

    print(result);
    if (result.isSuccess()) {
      print(result.getSuccess());
      emit(state.copyWith(shoppingLists: result.getSuccess()!));
    }
  }

  @override
  void onChange(Change<HomeState> change) {
    print(change);
    super.onChange(change);
  }
}
