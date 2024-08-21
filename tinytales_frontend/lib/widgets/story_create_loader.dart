import 'package:flutter/widgets.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/breakpoints.dart';
import 'package:tale_ai_frontend/widgets/multi_text_animation_loader.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class StoryCreateLoader extends StatelessWidget {
  const StoryCreateLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiTextAnimationLoader(
      texts: context.l10n.storyCreatingLoaderList
          .split(';')
          .toList(growable: false),
      image: SizedBox(
        width: appMaxContentWidth * 0.6,
        child: Assets.lottie.foxAnimation.lottie(),
      ),
    );
  }
}
