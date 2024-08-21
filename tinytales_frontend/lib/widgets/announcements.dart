import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/form/model/model.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/semantics_announcement.dart';

void announceAiAutofillChanges({
  required BuildContext context,
  required String? previousName,
  required String? previousDescription,
  required String? nextName,
  required String? nextDescription,
}) {
  final autofillNameChanged =
      previousName != nextName && nextName.isNotNullOrBlank;
  final autofillDescriptionChanged = previousDescription != nextDescription &&
      nextDescription.isNotNullOrBlank;

  if (autofillNameChanged || autofillDescriptionChanged) {
    semanticsAnnouncement(
      context: context,
      text: context.l10n.a11yCharacterAiAutofillResult(
        nextName ?? '',
        nextDescription ?? '',
      ),
    );
  }
}

void announceCharacterInputValidation({
  required BuildContext context,
  required Validation validation,
}) {
  switch (validation.validationStatus) {
    case ValidationStatus.inappropriate:
      semanticsAnnouncement(
        context: context,
        text: context.l10n.a11yCharacterValidationInappropriate(
          validation.message ?? '',
        ),
      );

    case ValidationStatus.needsImprovement:
      semanticsAnnouncement(
        context: context,
        text: context.l10n.a11yCharacterValidationNeedsImprovement(
          validation.message ?? '',
        ),
      );

    case ValidationStatus.excellent:
  }
}

void announceMoralInputValidation({
  required BuildContext context,
  required Validation validation,
}) {
  switch (validation.validationStatus) {
    case ValidationStatus.inappropriate:
      semanticsAnnouncement(
        context: context,
        text: context.l10n.a11yMoralValidationInappropriate(
          validation.message ?? '',
        ),
      );

    case ValidationStatus.needsImprovement:
      semanticsAnnouncement(
        context: context,
        text: context.l10n.a11yMoralValidationNeedsImprovement(
          validation.message ?? '',
        ),
      );

    case ValidationStatus.excellent:
  }
}

void announceCharacterInputAutofix({
  required BuildContext context,
  required String? name,
  required String? description,
}) {
  semanticsAnnouncement(
    context: context,
    text: context.l10n.a11yCharacterInputAutofix(
      name ?? '',
      description ?? '',
    ),
  );
}

void announceMoralInputAutofix({
  required BuildContext context,
  required String? moral,
}) {
  semanticsAnnouncement(
    context: context,
    text: context.l10n.a11yMoralInputAutofix(
      moral ?? '',
    ),
  );
}
