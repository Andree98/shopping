import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/utils/input_failure.dart';

class ListTitle {
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
