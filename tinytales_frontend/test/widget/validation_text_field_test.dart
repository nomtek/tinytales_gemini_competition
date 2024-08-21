import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/validation_text_field.dart';

import 'test_app.dart';

void main() {
  group('ValidationTextField Tests', () {
    void mockOnChanged(String value) {}

    const errorValidationWithMessage = Validation(
      valid: false,
      message: 'Error',
      validationStatus: ValidationStatus.inappropriate,
      suggestedVersion: SuggestedVersion(),
    );

    const errorValidationWithoutMessage = Validation(
      valid: false,
      validationStatus: ValidationStatus.inappropriate,
      suggestedVersion: SuggestedVersion(),
    );
    const warningValidationWithMessage = Validation(
      valid: true,
      message: 'Warning',
      validationStatus: ValidationStatus.needsImprovement,
      suggestedVersion: SuggestedVersion(),
    );
    const warningValidationWithoutMessage = Validation(
      valid: true,
      validationStatus: ValidationStatus.needsImprovement,
      suggestedVersion: SuggestedVersion(),
    );

    testWidgets('renders correctly with minimal required parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
          ),
        ),
      );

      expect(find.byType(ValidationTextField), findsOneWidget);
    });
    testWidgets('display warning with message when show error text is true',
        (tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
            validation: warningValidationWithMessage,
          ),
        ),
      );

      expect(find.text(warningValidationWithMessage.message!), findsOneWidget);
      expect(find.byType(WarningText), findsOneWidget);
    });

    testWidgets(
        'display warning with default message when show error text'
        ' is true and validation message is not provided', (tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
            validation: warningValidationWithoutMessage,
          ),
        ),
      );
      expect(
        find.text(
          lookupAppLocalizations(
            AppLocalizations.supportedLocales.first,
          ).characterInputsError,
        ),
        findsOneWidget,
      );

      expect(find.byType(WarningText), findsOneWidget);
    });

    testWidgets('display warning without message when show error text is false',
        (tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
            showErrorText: false,
            validation: warningValidationWithMessage,
          ),
        ),
      );

      expect(find.text(warningValidationWithMessage.message!), findsNothing);
      expect(find.byType(WarningText), findsOneWidget);
    });
    testWidgets('display error with message when show error text is true',
        (tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
            validation: errorValidationWithMessage,
          ),
        ),
      );

      expect(find.text(errorValidationWithMessage.message!), findsOneWidget);
      expect(find.byType(ErrorText), findsOneWidget);
    });

    testWidgets(
        'display error with default message when show error text'
        ' is true and validation message is not provided', (tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
            validation: errorValidationWithoutMessage,
          ),
        ),
      );
      expect(
        find.text(
          lookupAppLocalizations(
            AppLocalizations.supportedLocales.first,
          ).characterInputsError,
        ),
        findsOneWidget,
      );

      expect(find.byType(ErrorText), findsOneWidget);
    });

    testWidgets('display error without message when show error text is false',
        (tester) async {
      await tester.pumpWidget(
        TestAppWidget(
          child: ValidationTextField(
            onChanged: mockOnChanged,
            textController: TextEditingController(),
            isEnabled: true,
            showErrorText: false,
            validation: errorValidationWithMessage,
          ),
        ),
      );

      expect(find.text(errorValidationWithMessage.message!), findsNothing);
      expect(find.byType(ErrorText), findsOneWidget);
    });
  });
}
