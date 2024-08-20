import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/debug/debug_menu.dart';
import 'package:tale_ai_frontend/env/env.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/test_key_values.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: _HomePageImage(),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(28),
                _HomePageHeader(),
                Gap(32),
                Center(child: _HomePageCards()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomePageHeader extends StatelessWidget {
  const _HomePageHeader();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.surfaceContainerHigh.withOpacity(0.8),
      child: Column(
        children: [
          GestureDetector(
            onDoubleTap: kIsProd ? null : () => showDebugMenu(context),
            child: _HomeHorizontalPadding(
              child: Text(
                context.l10n.homePageTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.displaySmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
          if (!context.isMobileBreakpoint) ...[
            const Gap(8),
            Text(
              context.l10n.appSubtitle,
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HomePageCards extends StatelessWidget {
  const _HomePageCards();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _StoryCreatorCard(),
        _FreeformStoryCreatorCard(),
      ],
    );
  }
}

class _HomePageImage extends StatelessWidget {
  const _HomePageImage();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Idea here is to hide image when there is not enough space.
        // we don't want the image to go fully behind content
        // of home page.
        final imageSize = Assets.images.homeBg.size!;
        // A treshold to have a little bit of margin for
        // image to be still visible - after that margin image will dissapear.
        final treshhold = imageSize.height * 0.2;
        final spaceAboveImage = constraints.maxHeight / 2 + treshhold;
        // Arbitrary value to have some minimum height for image.
        // This is to avoid image to be too small.
        const minImageHeight = 200.0;
        final imageSpace = constraints.maxHeight - spaceAboveImage;
        final showImage = imageSpace >= minImageHeight;
        return Column(
          children: [
            SizedBox(height: spaceAboveImage),
            Expanded(
              child: AnimatedOpacity(
                opacity: showImage ? 1.0 : 0.0,
                duration: Durations.long1,
                child: Assets.images.homeBg.image(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StoryCreatorCard extends StatelessWidget {
  const _StoryCreatorCard();

  @override
  Widget build(BuildContext context) {
    return _HomeActionCard(
      text: _HomeActionCardText(
        context.l10n.homePageOpenStoryCreatorDescription,
      ),
      button: FilledButton(
        key: TestKeyValues.createStoryButtonKey,
        child: Text(
          context.l10n.homePageOpenStoryCreator,
        ),
        onPressed: () => StoryCreatorRoute().go(context),
      ),
    );
  }
}

class _FreeformStoryCreatorCard extends StatelessWidget {
  const _FreeformStoryCreatorCard();

  @override
  Widget build(BuildContext context) {
    return _HomeActionCard(
      text: _HomeActionCardText(
        context.l10n.homePageOpenFreeformDescription,
      ),
      button: OutlinedButton(
        child: Text(context.l10n.homePageOpenFreeformCreator),
        onPressed: () => FreeformPageRoute().go(context),
      ),
    );
  }
}

class _HomeActionCardText extends StatelessWidget {
  const _HomeActionCardText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: context.textTheme.titleMedium?.copyWith(
        color: context.colors.primary,
      ),
    );
  }
}

class _HomeActionCard extends StatelessWidget {
  const _HomeActionCard({
    required this.text,
    required this.button,
  });

  final Widget text;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    return MaxWidth(
      maxWidth: 330,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              text,
              const Gap(16),
              button,
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHorizontalPadding extends StatelessWidget {
  const _HomeHorizontalPadding({
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return PageHorizontalPadding(child: child);
  }
}
