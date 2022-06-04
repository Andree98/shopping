import 'package:flutter/foundation.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/create/entities/input_failure.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();

  Result<InputFailure, T> get value;

  bool isValid() => value.isSuccess();

  T get() => value.when(
        (error) => throw Error(), // Crash, should never be an error
        (success) => success,
      );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
