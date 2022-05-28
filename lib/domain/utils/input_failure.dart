import 'package:freezed_annotation/freezed_annotation.dart';

part 'input_failure.freezed.dart';

@freezed
class InputFailure with _$InputFailure {
  const factory InputFailure.empty() = _Empty;

  const factory InputFailure.invalid() = _Invalid;
}
