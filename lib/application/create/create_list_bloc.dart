import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:shopping/domain/create/create_list_interface.dart';
import 'package:shopping/domain/entities/title.dart';

part 'create_list_bloc.freezed.dart';
part 'create_list_event.dart';
part 'create_list_state.dart';

@injectable
class CreateListBloc extends Bloc<CreateListEvent, CreateListState> {
  final CreateListInterface _createListInterface;

  CreateListBloc(this._createListInterface) : super(CreateListState.initial()) {
    on<CreateListEvent>(
      (event, emit) async => event.map(
        titleChanged: (e) => _onTitleChangedEvent(e.input, emit),
      ),
    );
  }

  void _onTitleChangedEvent(String input, Emitter<CreateListState> emit) {
    emit(state.copyWith(title: ListTitle(input.trim())));
  }
}
