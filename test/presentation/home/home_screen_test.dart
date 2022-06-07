import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/application/home/home_cubit.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/create/screens/create_list_screen.dart';
import 'package:shopping/presentation/home/screens/home_screen.dart';
import 'package:shopping/presentation/home/widgets/shopping_list_item.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  late MockHomeCubit homeCubit;
  late MockCreateListBloc createListBloc;

  setUpAll(() {
    GetIt.instance
      ..registerFactory<HomeCubit>(() => homeCubit)
      ..registerFactory<CreateListBloc>(() => createListBloc);
  });

  setUp(() {
    homeCubit = MockHomeCubit();
    createListBloc = MockCreateListBloc();
  });

  testWidgets(
    'Should show a loading indicator and nothing else when the page is created',
    (tester) async {
      when(() => homeCubit.state).thenReturn(HomeState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('An error has occurred'), findsNothing);
      expect(find.text("You don't have any shopping lists"), findsNothing);
      expect(find.byType(Column), findsNothing);
    },
  );

  testWidgets(
    'Should show an error text when a failure state is emitted',
    (tester) async {
      when(() => homeCubit.state).thenReturn(
        HomeState.initial().copyWith(
          isLoading: false,
          getListsResult: const Failure(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsOneWidget);
      expect(find.text("You don't have any shopping lists"), findsNothing);
      expect(find.byType(Column), findsNothing);
    },
  );

  testWidgets(
    'Should show an empty text when an empty listings state is emitted',
    (tester) async {
      when(() => homeCubit.state).thenReturn(
        HomeState.initial().copyWith(
          isLoading: false,
          shoppingLists: [],
          getListsResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsNothing);
      expect(find.text("You don't have any shopping lists"), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    },
  );

  testWidgets(
    'Should show a column widget when a non empty listings state is emitted',
    (tester) async {
      when(() => homeCubit.state).thenReturn(
        HomeState.initial().copyWith(
          isLoading: false,
          shoppingLists: [createShoppingList()],
          getListsResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsNothing);
      expect(find.text("You don't have any shopping lists"), findsNothing);
      expect(find.byType(Column), findsOneWidget);
    },
  );

  testWidgets(
    'Should show a n number ShoppingListItem widget depending on the shopping list size',
    (tester) async {
      final shoppingLists = List.generate(5, (_) => createShoppingList());

      when(() => homeCubit.state).thenReturn(
        HomeState.initial().copyWith(
          isLoading: false,
          shoppingLists: shoppingLists,
          getListsResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
      );

      expect(
        find.byType(ShoppingListItem),
        findsNWidgets(shoppingLists.length),
      );
    },
  );

  testWidgets(
    'Should create a CreateListScreen widget when the add list button is tapped',
    (tester) async {
      when(() => homeCubit.state).thenReturn(
        HomeState.initial().copyWith(
          isLoading: false,
          shoppingLists: [createShoppingList()],
          getListsResult: const Success(anything),
        ),
      );

      when(() => createListBloc.state).thenReturn(CreateListState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<HomeCubit>(),
            child: const HomeScreen(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(CreateListScreen), findsOneWidget);
    },
  );
}
