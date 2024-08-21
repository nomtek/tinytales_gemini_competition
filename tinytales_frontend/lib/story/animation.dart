// This is a custom implementation to show animated text chunks.
// Most of it is based on [TypewriterAnimatedText] from the package.
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

const editModeAnimDuration = Duration(milliseconds: 250);
const editModeAnimCurve = Curves.ease;

class ChunksAnimatedText extends AnimatedText {
  ChunksAnimatedText(
    String text, {
    required this.numberOfChunks,
    super.textAlign,
    super.textStyle,
    this.speed = const Duration(milliseconds: 100),
    this.curve = Curves.linear,
  })  : chunkSize = text.characters.length ~/ numberOfChunks,
        super(
          text: text,
          duration: speed * numberOfChunks,
        );

  final Duration speed;

  final Curve curve;

  late Animation<double> _typingText;

  final int numberOfChunks;

  final int chunkSize;

  @override
  Duration get remaining => speed * (numberOfChunks - _typingText.value);

  @override
  void initAnimation(AnimationController controller) {
    _typingText = CurveTween(
      curve: curve,
    ).animate(controller);
  }

  @override
  Widget animatedBuilder(BuildContext context, Widget? child) {
    final charactersCount =
        (_typingText.value.clamp(0, 1) * numberOfChunks).round() * chunkSize;
    debugPrint('count: $charactersCount');

    assert(
      charactersCount <= textCharacters.length,
      'characters to display length should not be larger then the text length.',
    );
    final chunk = textCharacters.take(charactersCount).toString();
    return textWidget(chunk);
  }
}

class StoryFabAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({
    required Offset begin,
    required Offset end,
    required double progress,
  }) {
    if (progress < 0.5) {
      return begin;
    } else {
      return end;
    }
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    const Curve curve = Interval(0.5, 1, curve: editModeAnimCurve);
    return parent.drive(CurveTween(curve: curve));
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    const Curve curve = Interval(0.5, 1, curve: editModeAnimCurve);
    return parent.drive(CurveTween(curve: curve));
  }
}
