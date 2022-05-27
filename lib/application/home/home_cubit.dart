import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/repository_impl.dart';

part 'home_cubit.freezed.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final RepositoryImpl repositoryImpl;

  HomeCubit(this.repositoryImpl) : super(HomeState.initial());

  Future<void> testCreateList() async {
    const list = ShoppingList(title: 'Test list', items: {
      'Item 1': false,
      'Item 2': true,
    });

    final result = await repositoryImpl.createList(list);
    print(result.get());
  }
}
