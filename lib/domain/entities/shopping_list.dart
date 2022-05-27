import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String title,
    required Map<String, bool> items,
  }) = _ShoppingList;
}
