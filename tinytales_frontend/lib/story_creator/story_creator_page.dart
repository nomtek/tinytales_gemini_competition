import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_form.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class StoryCreatorPage extends StatelessWidget {
  const StoryCreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added as a solution to minimize the effect of bug
      // https://github.com/flutter/flutter/issues/124205
      // on mobile web.
      resizeToAvoidBottomInset: !isMobileWeb,
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () {
            showExitDialog(context: context).then(
              (result) {
                if (result == ConfirmationResult.confirm) {
                  context.pop();
                }
              },
            );
          },
        ),
        title: Text(context.l10n.storyCreatorTitle),
      ),
      body: const AppMaxContentWidth(
        child: SafeArea(
          child: StoryCreatorForm(),
        ),
      ),
    );
  }
}

Future<ConfirmationResult?> showExitDialog({
  required BuildContext context,
}) {
  return showDialog<ConfirmationResult?>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(context.l10n.storyCreatorExitDialogTitle),
      content: Text(context.l10n.storyCreatorExitDialogDescription),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, ConfirmationResult.cancel),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, ConfirmationResult.confirm);
          },
          child: Text(context.l10n.exit),
        ),
      ],
    ),
  );
}
