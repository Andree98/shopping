import 'package:bloc_test/bloc_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/domain/create/create_list_interface.dart';
import 'package:shopping/domain/details/list_details_interface.dart';
import 'package:shopping/domain/home/home_interface.dart';

class MockHttpClient extends Mock implements Client {}

class MockHomeInterface extends Mock implements HomeInterface {}

class MockCreateListInterface extends Mock implements CreateListInterface {}

class MockListDetailsInterface extends Mock implements ListDetailsInterface {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockCreateListBloc extends MockBloc<CreateListEvent, CreateListState>
    implements CreateListBloc {}
