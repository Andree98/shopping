import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation_failure.freezed.dart';

// Types of failures that validated objects can have

@freezed
class ValidationFailure with _$ValidationFailure {
  const factory ValidationFailure.empty(String message) = _Empty;

  const factory ValidationFailure.invalid(String message) = _Invalid;
}
