import 'package:multiple_result/multiple_result.dart';
import 'package:shopping/domain/create/entities/list_title.dart';
import 'package:shopping/domain/create/entities/validation_failure.dart';
import 'package:shopping/domain/create/utils/title_constants.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Should have a ValidationFailure.empty result with an empty title error message when the title is empty',
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
    'Should have a ValidationFailure.invalid result with an invalid title error message when the title is invalid',
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
    'Should have a success result with the valid title input when the title is valid',
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
