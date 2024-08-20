import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class AutofixTextButton extends StatelessWidget {
  const AutofixTextButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: context.customColors.warning,
        ),
      ),
      child: Text(
        context.l10n.autofixText,
        style: TextStyle(
          color: context.customColors.warning,
        ),
      ),
    );
  }
}
