import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item.freezed.dart';

part 'list_item.g.dart';

@freezed
class ListItem with _$ListItem {
  const factory ListItem({
    required String id,
    required String label,
    required bool isChecked,
  }) = _ListItem;

  factory ListItem.fromJson(Map<String, dynamic> json) =>
      _$ListItemFromJson(json);
}
