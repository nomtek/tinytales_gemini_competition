import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class ValidationTextField extends StatelessWidget {
  const ValidationTextField({
    required this.onChanged,
    required this.textController,
    required this.isEnabled,
    this.scrollController,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.validation,
    this.hintText,
    this.labelText,
    this.helperText,
    this.showErrorText = true,
    this.keyboardType,
    this.textInputAction,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController textController;
  final ScrollController? scrollController;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool isEnabled;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Validation? validation;
  // If showErrorText is false, the error message will not be shown it is used
  // to prevent the error message from being shown on name input field
  final bool showErrorText;

  @override
  Widget build(BuildContext context) {
    final validationStatus = validation?.validationStatus;
    final validationColor = validationStatus == ValidationStatus.inappropriate
        ? context.colors.error
        : context.customColors.warning;

    final isInputWarningOrError =
        !(validationStatus == ValidationStatus.excellent ||
            validationStatus == null);

    final errorText = validation?.message ?? context.l10n.characterInputsError;

    return TextFormField(
      onChanged: onChanged,
      controller: textController,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      cursorErrorColor: validationColor,
      enabled: isEnabled,
      scrollController: scrollController,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        error: isInputWarningOrError
            ? validationStatus == ValidationStatus.inappropriate
                ? ErrorText(
                    message: showErrorText ? errorText : '',
                  )
                : WarningText(
                    message: showErrorText
                        ? validation?.message ??
                            context.l10n.characterInputsError
                        : '',
                  )
            : null,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: validationColor,
          ),
        ),
        errorStyle: TextStyle(
          color: validationColor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: validationColor,
          ),
        ),
        labelText: labelText,
        labelStyle: TextStyle(
          color: isInputWarningOrError ? validationColor : null,
        ),
        hintText: hintText,
        helperText: helperText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
