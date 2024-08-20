import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class FormNavigationButtons extends StatelessWidget {
  const FormNavigationButtons({
    required this.isProceedButtonEnabled,
    required this.onProceedButtonPressed,
    required this.isGoBackVisible,
    required this.onGoBackButtonPressed,
    required this.isCreateButtonVisible,
    required this.onCreteButtonPressed,
    super.key,
  });

  final bool isProceedButtonEnabled;
  final VoidCallback onProceedButtonPressed;
  final bool isGoBackVisible;
  final VoidCallback onGoBackButtonPressed;
  final bool isCreateButtonVisible;
  final VoidCallback onCreteButtonPressed;

  @override
  Widget build(BuildContext context) {
    final goBackButton = isGoBackVisible
        ? OutlinedButton(
            onPressed: () {
              assert(
                isGoBackVisible,
                'Cannot go back when button is disabled.',
              );
              if (isGoBackVisible) {
                onGoBackButtonPressed();
              }
            },
            child: Text(context.l10n.storyCreatorActionBack),
          )
        : null;

    final Widget actionButton;
    if (isCreateButtonVisible) {
      actionButton = FilledButton(
        onPressed: isProceedButtonEnabled
            ? () {
                assert(
                  isProceedButtonEnabled,
                  'We should not be able to go to '
                  'the next step when button is disabled.',
                );
                onCreteButtonPressed();
              }
            : null,
        child: Text(context.l10n.storyCreatorActionCreate),
      );
    } else {
      actionButton = FilledButton(
        onPressed: isProceedButtonEnabled
            ? () {
                assert(
                  isProceedButtonEnabled,
                  'We should not be able to go to '
                  'the next step when button is disabled.',
                );
                onProceedButtonPressed();
              }
            : null,
        child: Text(context.l10n.storyCreatorActionNext),
      );
    }

    return AppButtonBar(
      primaryButton: actionButton,
      secondaryButton: goBackButton,
    );
  }
}
