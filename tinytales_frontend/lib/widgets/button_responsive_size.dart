import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

class ButtonResponsiveSize extends StatelessWidget {
  const ButtonResponsiveSize({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final buttonWidth = ResponsiveValue<double>(
      context,
      conditionalValues: const [
        Condition.equals(name: TABLET, value: 327),
        Condition.equals(name: DESKTOP, value: 200),
      ],
      defaultValue: mobileMaxWidth,
    ).value;
    return Center(
      child: AnimatedContainer(
        duration: Durations.short2,
        constraints: BoxConstraints(
          minWidth: buttonWidth,
        ),
        child: child,
      ),
    );
  }
}
