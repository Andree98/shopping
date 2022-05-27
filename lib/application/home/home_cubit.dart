import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/repository_impl.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final RepositoryImpl _repositoryImpl;

  HomeCubit(this._repositoryImpl) : super(HomeState.initial());

  Future<void> loadShoppingLists() async {
    final result = await _repositoryImpl.getAllShoppingLists();

    emit(
      state.copyWith(
        isLoading: false,
        shoppingLists: result.getSuccess() ?? [],
        getListsResult: result,
      ),
    );
  }
}
