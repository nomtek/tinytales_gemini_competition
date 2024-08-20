import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/story/animation.dart';

export 'audio.dart';

class StoryAnimatedSwitcher extends StatelessWidget {
  const StoryAnimatedSwitcher({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: editModeAnimDuration,
      switchInCurve: editModeAnimCurve,
      switchOutCurve: editModeAnimCurve.flipped,
      child: child,
    );
  }
}
