import 'package:shopping/domain/common/entities/shopping_list.dart';
import 'package:shopping/domain/common/entities/shopping_list_dto.dart';

extension ShoppingListDtoMapper on ShoppingListDto {
  ShoppingList toShoppingList() {
    return ShoppingList(
      id: id,
      title: title,
      created: created,
      items: items?.entries.map((e) => e.value).toList() ?? [],
    );
  }
}

extension ShoppingListMapper on ShoppingList {
  ShoppingListDto toShoppingListDto() {
    return ShoppingListDto(
      id: id,
      title: title,
      created: created,
      items: Map.fromEntries(items.map((e) => MapEntry(e.id, e))),
    );
  }
}
