import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/button_responsive_size.dart';

/// Responsive container for 2 buttons.
///
/// On desktop, buttons are displayed in a row.
///
/// On mobile, buttons are displayed in a column.
class AppButtonBar extends StatelessWidget {
  const AppButtonBar({
    this.primaryButton,
    this.secondaryButton,
    super.key,
  });

  final Widget? primaryButton;
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    final effectivePrimaryButton = primaryButton != null
        ? ButtonResponsiveSize(child: primaryButton!)
        : null;

    final effectiveSecondaryButton = secondaryButton != null
        ? ButtonResponsiveSize(child: secondaryButton!)
        : null;

    if (effectivePrimaryButton == null && effectiveSecondaryButton == null) {
      return const SizedBox();
    }
    final Widget buttons;
    if (context.isDesktopBreakpoint) {
      buttons = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (effectiveSecondaryButton != null) ...[
            effectiveSecondaryButton,
            const Gap(8),
          ],
          if (effectivePrimaryButton != null) effectivePrimaryButton,
        ],
      );
    } else {
      buttons = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (effectivePrimaryButton != null) effectivePrimaryButton,
          if (effectiveSecondaryButton != null) effectiveSecondaryButton,
        ],
      );
    }
    return _ButtonBarPadding(child: buttons);
  }
}

class _ButtonBarPadding extends StatelessWidget {
  const _ButtonBarPadding({
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final topPadding = ResponsiveValue<double>(
      context,
      conditionalValues: [
        const Condition.equals(name: DESKTOP, value: 56),
      ],
      defaultValue: 24,
    ).value;

    return AnimatedPadding(
      duration: Durations.short2,
      padding: EdgeInsets.only(top: topPadding, bottom: 24),
      child: child,
    );
  }
}
