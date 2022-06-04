import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/create/entities/list_title.dart';
import 'package:shopping/domain/create/entities/validation_failure.dart';
import 'package:shopping/domain/create/utils/title_constants.dart';
import 'package:test/test.dart';

void main() {
  test(
    'When the title is empty, the result should be a ValidationFailure.empty with an empty title error message',
    () {
      // Arrange
      const emptyTitle = '';

      // Act
      final titleResult = ListTitle(emptyTitle).value;

      // Assert
      expect(
        titleResult,
        const Failure(ValidationFailure.empty(kEmptyTitleError)),
      );
    },
  );

  test(
    'When the title is invalid, the result should be a ValidationFailure.invalid with an invalid title error message',
    () {
      // Arrange
      const invalidTitle = 'ti';

      // Act
      final titleResult = ListTitle(invalidTitle).value;

      // Assert
      expect(
        titleResult,
        const Failure(ValidationFailure.invalid(kInvalidTitleError)),
      );
    },
  );

  test(
    'When the title is valid, the result should be a success with the valid title input',
    () {
      // Arrange
      const validTitle = 'title';

      // Act
      final titleResult = ListTitle(validTitle).value;

      // Assert
      expect(titleResult, const Success(validTitle));
    },
  );
}
