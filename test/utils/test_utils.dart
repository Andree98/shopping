import 'dart:math';

import 'package:shopping/domain/common/entities/list_item.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:uuid/uuid.dart';

ShoppingList createShoppingList() {
  return ShoppingList(
    id: const Uuid().v4(),
    title: 'title',
    created: DateTime.now().millisecondsSinceEpoch,
    items: List.generate(10, (index) => createListItem()),
  );
}

ListItem createListItem() {
  return ListItem(
    id: const Uuid().v4(),
    label: 'Label',
    isChecked: Random().nextBool(),
  );
}
