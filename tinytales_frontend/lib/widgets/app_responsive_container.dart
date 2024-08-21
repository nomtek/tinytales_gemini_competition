import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

/// A widget that limits the width of its child.
class MaxWidth extends StatelessWidget {
  const MaxWidth({
    required this.child,
    super.key,
    this.maxWidth,
  });

  final double? maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // stack here is important to make sure the child is centered
    // and not stretched to the full width
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(width: maxWidth, child: child),
      ],
    );
  }
}

class AppMaxContentWidth extends StatelessWidget {
  const AppMaxContentWidth({
    required this.child,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: MaxWidth(
        maxWidth: appMaxContentWidth,
        child: child,
      ),
    );
  }
}

class AppResponsiveContentPadding extends StatelessWidget {
  const AppResponsiveContentPadding({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final paddingHorizontal = ResponsiveValue<double>(
      context,
      conditionalValues: [
        const Condition.equals(name: TABLET, value: 50),
        const Condition.equals(name: DESKTOP, value: 100),
      ],
      defaultValue: 0,
    ).value;

    final paddingVertical = ResponsiveValue<double>(
      context,
      conditionalValues: [
        const Condition.equals(name: DESKTOP, value: 64),
      ],
      defaultValue: 0,
    ).value;

    final contentPadding = EdgeInsets.symmetric(
      vertical: paddingVertical,
      horizontal: paddingHorizontal,
    );

    return AnimatedPadding(
      padding: contentPadding,
      duration: Durations.short2,
      child: child,
    );
  }
}
