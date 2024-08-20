import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

@immutable
class MultiTextAnimationLoader extends StatelessWidget {
  const MultiTextAnimationLoader({
    required this.texts,
    this.image,
    this.duration = const Duration(milliseconds: 3500),
    this.pause = const Duration(milliseconds: 200),
    super.key,
  });

  final List<String> texts;

  // how long each text should be displayed
  final Duration duration;

  // how long to pause between each text
  final Duration pause;

  // optional image to show above the text
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null) ...[
            Flexible(child: image!),
            const Gap(16),
          ],
          if (texts.length == 1)
            Text(
              texts.first,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colors.primary,
              ),
            )
          else
            Stack(
              children: [
                // added to have a consistent height
                // without it AnimatedTextKit changes height when text changes
                Text(
                  '',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: context.colors.primary,
                  ),
                ),
                AnimatedTextKit(
                  pause: pause,
                  animatedTexts: [
                    for (final text in texts)
                      FadeAnimatedText(
                        text,
                        textStyle: context.textTheme.headlineSmall?.copyWith(
                          color: context.colors.primary,
                        ),
                        duration: duration,
                      ),
                  ],
                  repeatForever: true,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
