import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/create/entities/input_failure.dart';
import 'package:shopping/domain/create/entities/value_object.dart';

class ListTitle extends ValueObject {
  @override
  final Result<InputFailure, String> value;

  factory ListTitle(String input) => ListTitle._(_validateTitle(input));

  const ListTitle._(this.value);

  static Result<InputFailure, String> _validateTitle(String input) {
    if (input.isEmpty) {
      return const Failure(InputFailure.empty());
    } else if (input.length < 3) {
      return const Failure(InputFailure.invalid());
    } else {
      return Success(input);
    }
  }
}
