import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shopping/domain/common/entities/shopping_list.dart';

part 'details_action.freezed.dart';

@freezed
class DetailsAction with _$DetailsAction {
  const factory DetailsAction.updated(ShoppingList? list) = _Updated;

  const factory DetailsAction.deleted() = _Deleted;
}
