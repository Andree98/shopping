import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_item.freezed.dart';

@freezed
class ListItem with _$ListItem {
  const factory ListItem({
    required String label,
    required bool isChecked,
  }) = _ListItem;
}
