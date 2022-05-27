import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list_dto.freezed.dart';

part 'shopping_list_dto.g.dart';

@freezed
class ShoppingListDto with _$ShoppingListDto {
  const factory ShoppingListDto({
    required String title,
    required Map<String, bool> items,
  }) = _ShoppingListDto;

  factory ShoppingListDto.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListDtoFromJson(json);
}
