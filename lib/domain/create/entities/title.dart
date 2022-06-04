import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/create/entities/validated_object.dart';
import 'package:shopping/domain/create/entities/validation_failure.dart';

class ListTitle extends ValidatedObject {
  @override
  final Result<ValidationFailure, String> value;

  factory ListTitle(String input) => ListTitle._(_validateTitle(input));

  const ListTitle._(this.value);

  static Result<ValidationFailure, String> _validateTitle(String input) {
    if (input.isEmpty) {
      return const Failure(ValidationFailure.empty('Title cannot be empty'));
    } else if (input.length < 3) {
      return const Failure(
        ValidationFailure.invalid('Title must contain at least 3 characters'),
      );
    } else {
      return Success(input);
    }
  }
}
