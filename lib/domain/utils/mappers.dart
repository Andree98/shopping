import 'package:shopping/domain/entities/shopping_list.dart';
import 'package:shopping/domain/entities/shopping_list_dto.dart';

extension ShoppingListDtoMapper on ShoppingListDto {
  ShoppingList toShoppingList() {
    return ShoppingList(id: id, title: title, items: items);
  }
}

extension ShoppingListMapper on ShoppingList {
  ShoppingListDto toShoppingListDto() {
    return ShoppingListDto(id: id, title: title, items: items);
  }
}
