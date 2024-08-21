import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/freeform/form/freeform_navigation_buttons.dart';
import 'package:tale_ai_frontend/freeform/state/state.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'content_step.g.dart';

@riverpod
ContentStepState _contentStep(_ContentStepRef ref) {
  return ref.watch(freeformNotifierProvider).contentStep;
}

class FreeformContentStep extends HookConsumerWidget {
  const FreeformContentStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(
      text: ref.read(_contentStepProvider).content,
    );
    final canSubmit = useState(false);

    useEffect(
      () {
        final controller = textController;
        void listener() {
          canSubmit.value = controller.text.isNotEmpty;
        }

        controller.addListener(listener);
        return () => controller.removeListener(listener);
      },
      [textController],
    );

    final stepState = ref.watch(_contentStepProvider);

    return AppScrollableContentScaffold(
      scrollableContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            context.l10n.freeformPageSubtitle,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(8),
          Text(
            context.l10n.freeformPageDescription,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.primary,
            ),
          ),
          const Gap(32),
          ValidationTextField(
            onChanged: (value) {
              ref
                  .read(freeformNotifierProvider.notifier)
                  .setFreeformContent(value);
            },
            minLines: 8,
            maxLines: 8,
            validation: stepState.validation,
            isEnabled: true,
            maxLength: 500,
            labelText: context.l10n.freeformPageInputLabel,
            hintText: context.l10n.freeformPageInputHint,
            textController: textController,
          ),
          if (stepState.validation?.showAutofixForOneField ?? false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(8),
                AutofixTextButton(
                  onPressed: () {
                    textController.text =
                        stepState.validation?.suggestedVersion.content ?? '';

                    ref
                        .read(freeformNotifierProvider.notifier)
                        .setFreeformContent(
                          stepState.validation?.suggestedVersion.content ?? '',
                        );
                  },
                ),
              ],
            ),
        ],
      ),
      bottomContent: const FreeformNavigationButtons(),
    );
  }
}
