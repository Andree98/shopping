import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping/application/create/create_list_bloc.dart';
import 'package:shopping/injection.dart';
import 'package:shopping/presentation/common/widgets/new_item_dialog.dart';
import 'package:shopping/presentation/create/screens/create_list_screen.dart';
import 'package:shopping/presentation/create/widgets/create_list_item.dart';

import '../../utils/mocks.dart';
import '../../utils/test_utils.dart';

void main() {
  final items = List.generate(5, (index) => createListItem());
  late MockCreateListBloc createListBloc;

  setUpAll(() {
    GetIt.instance.registerFactory<CreateListBloc>(() => createListBloc);
  });

  setUp(() {
    createListBloc = MockCreateListBloc();
  });

  testWidgets(
    'Should show a loading LinearProgressBar when the state is saving',
    (tester) async {
      when(() => createListBloc.state).thenReturn(
        CreateListState.initial().copyWith(
          isSaving: true,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<CreateListBloc>(),
            child: const CreateListScreen(),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should show a text with when the items list is empty',
    (tester) async {
      when(() => createListBloc.state).thenReturn(CreateListState.initial());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<CreateListBloc>(),
            child: const CreateListScreen(),
          ),
        ),
      );

      expect(find.text('List is empty'), findsOneWidget);
    },
  );

  testWidgets(
    'Should show a number of CreateListItem widgets depending on the state item list size',
    (tester) async {
      when(() => createListBloc.state).thenReturn(
        CreateListState.initial().copyWith(items: items),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<CreateListBloc>(),
            child: const CreateListScreen(),
          ),
        ),
      );

      expect(find.byType(CreateListItem), findsNWidgets(items.length));
    },
  );

  testWidgets(
    'Should show a NewItemDialog when the floating action button is tapped',
    (tester) async {
      when(() => createListBloc.state).thenReturn(
        CreateListState.initial().copyWith(items: items),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => getIt<CreateListBloc>(),
            child: const CreateListScreen(),
          ),
        ),
      );

      expect(find.byType(CreateListItem), findsNWidgets(items.length));

      await tester.tap(find.byType(FloatingActionButton));

      await tester.pumpAndSettle();

      expect(find.byType(NewItemDialog), findsOneWidget);
    },
  );
}
