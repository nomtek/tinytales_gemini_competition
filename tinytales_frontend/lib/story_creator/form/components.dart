import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/semantics_announcement.dart';

class AiAutofillButton extends StatelessWidget {
  const AiAutofillButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.aiAutofill,
      child: ExcludeSemantics(
        child: TextButton.icon(
          icon: Builder(
            builder: (context) {
              // builder is needed to get the context of the TextButton
              // which provides the correct IconTheme
              // to display properly disabled icon
              return Assets.icons.aiSparkles.svg(
                colorFilter: ColorFilter.mode(
                  IconTheme.of(context).color!,
                  BlendMode.srcIn,
                ),
              );
            },
          ),
          onPressed: onPressed != null
              ? () {
                  onPressed!();
                  semanticsAnnouncement(
                    context: context,
                    text: context.l10n.a11yAiAutofillResult,
                  );
                }
              : null,
          label: Text(context.l10n.aiAutofill),
        ),
      ),
    );
  }
}

Future<void> updateTextFieldInChunks({
  required TextEditingController controller,
  required Duration duration,
  required String? value,
  required BuildContext context,
  VoidCallback? onUpdateStart,
  VoidCallback? onUpdateEnd,
  ScrollController? scrollController,
}) async {
  if (controller.text != value && value != null && value.isNotEmpty) {
    if (context.mounted) onUpdateStart?.call();
    final characterDelay = duration ~/ value.characters.length;
    final characters = value.characters;
    controller.text = '';

    for (final character in characters) {
      if (!context.mounted) {
        return;
      }
      controller.text += character;
      if (controller.text.length < characters.length) {
        await Future<void>.delayed(characterDelay);
        if (scrollController != null && scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      }
    }
    if (context.mounted) onUpdateEnd?.call();
  }
}

class TextFieldCircleIndicator extends StatelessWidget {
  const TextFieldCircleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: Align(
        // Padding is needed to center the CircularProgressIndicator
        // in the TextField
        child: Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
