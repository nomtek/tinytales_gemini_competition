import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';

enum ConfirmationResult {
  confirm,
  cancel,
}

/// [onConfirm] will be called when user confirms the action.
/// It's done before the dialog is closed.
/// To handle the action after the dialog
/// is closed await [showConfirmationDialog].
Future<ConfirmationResult?> showConfirmationDialog({
  required BuildContext context,
  required String description,
  required VoidCallback onConfirm,
}) {
  return showDialog<ConfirmationResult>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: Text(description),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, ConfirmationResult.cancel),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context, ConfirmationResult.confirm);
          },
          child: Text(context.l10n.confirm),
        ),
      ],
    ),
  );
}
