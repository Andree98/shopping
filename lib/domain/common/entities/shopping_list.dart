import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopping/domain/common/entities/list_item.dart';

part 'shopping_list.freezed.dart';

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    required String title,
    required int created,
    required List<ListItem> items,
  }) = _ShoppingList;
}
