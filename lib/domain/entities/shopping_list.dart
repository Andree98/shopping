import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    required String title,
    required int created,
    required Map<String, bool> items,
  }) = _ShoppingList;
}
