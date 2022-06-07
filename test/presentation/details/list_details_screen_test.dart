import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/application/details/list_details_bloc.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/common/widgets/new_item_dialog.dart';
import 'package:shopping/presentation/details/screens/list_details_screen.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  late MockListDetailsBloc listDetailsBloc;

  setUpAll(() {
    GetIt.instance.registerFactory<ListDetailsBloc>(() => listDetailsBloc);
  });

  setUp(() {
    listDetailsBloc = MockListDetailsBloc();
  });

  testWidgets(
    'Should show a loading indicator and nothing else when the page is created',
    (tester) async {
      when(() => listDetailsBloc.state).thenReturn(ListDetailsState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<ListDetailsBloc>(),
            child: const ListDetailsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('An error has occurred'), findsNothing);
      expect(find.text('No items'), findsNothing);
      expect(find.byType(Column), findsNothing);
    },
  );

  testWidgets(
    'Should show an error text when a failure state is emitted',
    (tester) async {
      when(() => listDetailsBloc.state).thenReturn(
        ListDetailsState.initial().copyWith(
          isLoading: false,
          loadListResult: const Failure(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<ListDetailsBloc>(),
            child: const ListDetailsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsOneWidget);
      expect(find.text('No items'), findsNothing);
      expect(find.byType(ListView), findsNothing);
    },
  );

  testWidgets(
    'Should show an error text when a null ShoppingList is emitted',
    (tester) async {
      when(() => listDetailsBloc.state).thenReturn(
        ListDetailsState.initial().copyWith(
          isLoading: false,
          shoppingList: null,
          loadListResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<ListDetailsBloc>(),
            child: const ListDetailsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsOneWidget);
      expect(find.text('No items'), findsNothing);
      expect(find.byType(ListView), findsNothing);
    },
  );

  testWidgets(
    'Should show an empty text when an empty items list is emitted',
    (tester) async {
      when(() => listDetailsBloc.state).thenReturn(
        ListDetailsState.initial().copyWith(
          isLoading: false,
          shoppingList: createShoppingList().copyWith(items: []),
          loadListResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<ListDetailsBloc>(),
            child: const ListDetailsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsNothing);
      expect(find.text('No items'), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
    },
  );

  testWidgets(
    'Should show a ListView widget when a non empty items list is emitted',
    (tester) async {
      when(() => listDetailsBloc.state).thenReturn(
        ListDetailsState.initial().copyWith(
          isLoading: false,
          shoppingList: createShoppingList(),
          loadListResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<ListDetailsBloc>(),
            child: const ListDetailsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('An error has occurred'), findsNothing);
      expect(find.text('No items'), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    },
  );

  testWidgets(
    'Should show a NewItemDialog when the floating action button is tapped',
    (tester) async {
      when(() => listDetailsBloc.state).thenReturn(
        ListDetailsState.initial().copyWith(
          isLoading: false,
          shoppingList: createShoppingList(),
          loadListResult: const Success(anything),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<ListDetailsBloc>(),
            child: const ListDetailsScreen(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));

      await tester.pumpAndSettle();

      expect(find.byType(NewItemDialog), findsOneWidget);
    },
  );
}
