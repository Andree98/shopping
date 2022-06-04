import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopping/domain/common/entities/list_item.dart';

part 'details_action.freezed.dart';

@freezed
class DetailsAction with _$DetailsAction {
  const factory DetailsAction.updated(List<ListItem> items) = _Updated;

  const factory DetailsAction.deleted() = _Deleted;
}
