import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/components.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

@immutable
class CharacterInputParams with EquatableMixin {
  const CharacterInputParams({
    required this.textController,
    required this.onInputChanged,
    required this.isInputEnabled,
  });

  final TextEditingController textController;
  final ValueChanged<String> onInputChanged;
  final bool isInputEnabled;

  @override
  List<Object?> get props => [
        textController,
        onInputChanged,
        isInputEnabled,
      ];
}

class DescriptionInputParams extends CharacterInputParams with EquatableMixin {
  const DescriptionInputParams({
    required super.textController,
    required this.scrollController,
    required super.onInputChanged,
    required super.isInputEnabled,
  });

  final ScrollController scrollController;

  @override
  List<Object?> get props => [
        textController,
        scrollController,
        onInputChanged,
        isInputEnabled,
      ];
}

class CharacterInput extends StatelessWidget {
  const CharacterInput({
    required this.nameInputParams,
    required this.descriptionInputParams,
    required this.isAIAutofillLoading,
    required this.onAIAutofillPressed,
    required this.onAutofixPressed,
    this.validation,
    super.key,
  });

  static const nameInputKey = Key('character_name_input');
  static const descriptionInputKey = Key('character_description_input');

  final CharacterInputParams nameInputParams;
  final DescriptionInputParams descriptionInputParams;
  final bool isAIAutofillLoading;
  final VoidCallback onAIAutofillPressed;
  final VoidCallback onAutofixPressed;

  final Validation? validation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValidationTextField(
          key: nameInputKey,
          onChanged: nameInputParams.onInputChanged,
          textController: nameInputParams.textController,
          isEnabled: nameInputParams.isInputEnabled,
          helperText: '',
          showErrorText: false,
          validation: validation,
          labelText: context.l10n.characterNameInputLabel,
          hintText: context.l10n.characterNameInputHint,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                ValidationTextField(
                  key: descriptionInputKey,
                  validation: validation,
                  onChanged: descriptionInputParams.onInputChanged,
                  textController: descriptionInputParams.textController,
                  scrollController: descriptionInputParams.scrollController,
                  isEnabled: descriptionInputParams.isInputEnabled,
                  minLines: 4,
                  maxLines: 4,
                  labelText: context.l10n.characterDescriptionInputLabel,
                  hintText: context.l10n.characterDescriptionInputHint,
                ),
                if (isAIAutofillLoading) const TextFieldCircleIndicator(),
              ],
            ),
            Row(
              children: [
                Visibility(
                  visible: validation?.showShowAutofixForTwoFields ?? false,
                  child: AutofixTextButton(
                    onPressed: onAutofixPressed,
                  ),
                ),
                const Spacer(),
                AiAutofillButton(
                  onPressed: nameInputParams.isInputEnabled &&
                          descriptionInputParams.isInputEnabled
                      ? onAIAutofillPressed
                      : null,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
