import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shopping/main.dart' as app;
import 'package:shopping/presentation/create/widgets/create_list_item.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Create and delete shopping list test', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Open the CreateListScreen
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Type the title
    final title = 'Title ${Random().nextInt(50)}';
    await tester.enterText(find.byType(TextFormField), title);

    // Show the NewItemDialog when fab is tapped
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Type the new item label in the dialog text field and confirm
    final itemLabel = 'Item ${Random().nextInt(50)}';
    await tester.enterText(find.byType(TextFormField), itemLabel);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm')));
    await tester.pumpAndSettle();

    // Expect the new item in the list
    expect(find.byType(CreateListItem), findsOneWidget);
    expect(find.text(itemLabel), findsOneWidget);

    // Save the list
    await tester.tap(find.byKey(const Key('save')));
    await tester.pumpAndSettle();

    // Check if the new shopping list has been added
    expect(find.text(title), findsOneWidget);

    // Open the ListDetailsScreen for the added shopping list
    await tester.tap(find.text(title));
    await tester.pumpAndSettle();

    // Click the delete button to show the confirm deletion dialog
    await tester.tap(find.byKey(const Key('delete')));
    await tester.pumpAndSettle();

    // Confirm the deletion
    await tester.tap(find.byKey(const Key('confirm_delete')));
    await tester.pumpAndSettle();

    // Check if the shopping list has been deleted
    expect(find.text(title), findsNothing);
  });
}
