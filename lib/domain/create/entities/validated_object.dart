import 'package:flutter/foundation.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/create/entities/validation_failure.dart';

/// Parent class of classes that need to be validated, in this case only
/// the list title needs to be validated (can't be empty or less than 3 chars)

@immutable
abstract class ValidatedObject<T> {
  const ValidatedObject();

  Result<ValidationFailure, T> get value;

  bool isValid() => value.isSuccess();

  T get() => value.when(
        (error) => throw Error(), // Crash, should never be an error
        (success) => success,
      );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ValidatedObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
