import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/theme/theme_mode.dart';

void showThemeShowcase(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => const ThemeShowcase(),
    ),
  );
}

class ThemeShowcase extends StatelessWidget {
  const ThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            _TextThemeShowcase(),
            Gap(16),
            _ColorsShowcase(),
          ],
        ),
      ),
    );
  }
}

class _TextThemeShowcase extends StatelessWidget {
  const _TextThemeShowcase();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FontStyle(
          'Display large',
          style: context.textTheme.displayLarge,
        ),
        _FontStyle(
          'Display medium',
          style: context.textTheme.displayMedium,
        ),
        _FontStyle(
          'Display small',
          style: context.textTheme.displaySmall,
        ),
        _FontStyle(
          'Headline large',
          style: context.textTheme.headlineLarge,
        ),
        _FontStyle(
          'Headline medium',
          style: context.textTheme.headlineMedium,
        ),
        _FontStyle(
          'Headline small',
          style: context.textTheme.headlineSmall,
        ),
        _FontStyle(
          'Title large',
          style: context.textTheme.titleLarge,
        ),
        _FontStyle(
          'Title medium',
          style: context.textTheme.titleMedium,
        ),
        _FontStyle(
          'Title small',
          style: context.textTheme.titleSmall,
        ),
        _FontStyle(
          'Body large',
          style: context.textTheme.bodyLarge,
        ),
        _FontStyle(
          'Body medium',
          style: context.textTheme.bodyMedium,
        ),
        _FontStyle(
          'Body small',
          style: context.textTheme.bodySmall,
        ),
        _FontStyle(
          'Label large',
          style: context.textTheme.labelLarge,
        ),
        _FontStyle(
          'Label medium',
          style: context.textTheme.labelMedium,
        ),
        _FontStyle(
          'Label small',
          style: context.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _FontStyle extends StatelessWidget {
  const _FontStyle(
    this.exampleText, {
    required this.style,
  });

  final String exampleText;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(exampleText, style: style),
            const Gap(8),
            Text('fontFamily: ${style?.fontFamily}'),
            Text('fontSize: ${style?.fontSize}'),
            Text('fontWeight: ${style?.fontWeight}'),
            Text('fontStyle: ${style?.fontStyle}'),
            Text('letterSpacing: ${style?.letterSpacing}'),
            Text('wordSpacing: ${style?.wordSpacing}'),
            Text('height: ${style?.height}'),
            Text(
              'line-height: '
              '${style != null ? (style!.fontSize! * style!.height!) : null}',
            ),
            Text('color: ${style?.color}'),
          ],
        ),
      ),
    );
  }
}

class _ColorsShowcase extends StatelessWidget {
  const _ColorsShowcase();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        _ColorBox(
          color: colors.primary,
          name: 'primary',
        ),
        _ColorBox(
          color: colors.onPrimary,
          name: 'onPrimary',
        ),
        _ColorBox(
          color: colors.primaryContainer,
          name: 'primaryContainer',
        ),
        _ColorBox(
          color: colors.onPrimaryContainer,
          name: 'onPrimaryContainer',
        ),
        _ColorBox(
          color: colors.primaryFixed,
          name: 'primaryFixed',
        ),
        _ColorBox(
          color: colors.primaryFixedDim,
          name: 'primaryFixedDim',
        ),
        _ColorBox(
          color: colors.onPrimaryFixed,
          name: 'onPrimaryFixed',
        ),
        _ColorBox(
          color: colors.onPrimaryFixedVariant,
          name: 'onPrimaryFixedVariant',
        ),
        _ColorBox(
          color: colors.secondary,
          name: 'secondary',
        ),
        _ColorBox(
          color: colors.onSecondary,
          name: 'onSecondary',
        ),
        _ColorBox(
          color: colors.secondaryContainer,
          name: 'secondaryContainer',
        ),
        _ColorBox(
          color: colors.onSecondaryContainer,
          name: 'onSecondaryContainer',
        ),
        _ColorBox(
          color: colors.secondaryFixed,
          name: 'secondaryFixed',
        ),
        _ColorBox(
          color: colors.secondaryFixedDim,
          name: 'secondaryFixedDim',
        ),
        _ColorBox(
          color: colors.onSecondaryFixed,
          name: 'onSecondaryFixed',
        ),
        _ColorBox(
          color: colors.onSecondaryFixedVariant,
          name: 'onSecondaryFixedVariant',
        ),
        _ColorBox(
          color: colors.tertiary,
          name: 'tertiary',
        ),
        _ColorBox(
          color: colors.onTertiary,
          name: 'onTertiary',
        ),
        _ColorBox(
          color: colors.tertiaryContainer,
          name: 'tertiaryContainer',
        ),
        _ColorBox(
          color: colors.onTertiaryContainer,
          name: 'onTertiaryContainer',
        ),
        _ColorBox(
          color: colors.tertiaryFixed,
          name: 'tertiaryFixed',
        ),
        _ColorBox(
          color: colors.tertiaryFixedDim,
          name: 'tertiaryFixedDim',
        ),
        _ColorBox(
          color: colors.onTertiaryFixed,
          name: 'onTertiaryFixed',
        ),
        _ColorBox(
          color: colors.onTertiaryFixedVariant,
          name: 'onTertiaryFixedVariant',
        ),
        _ColorBox(
          color: colors.error,
          name: 'error',
        ),
        _ColorBox(
          color: colors.onError,
          name: 'onError',
        ),
        _ColorBox(
          color: colors.errorContainer,
          name: 'errorContainer',
        ),
        _ColorBox(
          color: colors.onErrorContainer,
          name: 'onErrorContainer',
        ),
        _ColorBox(
          color: colors.surface,
          name: 'surface',
        ),
        _ColorBox(
          color: colors.onSurface,
          name: 'onSurface',
        ),
        _ColorBox(
          color: colors.surfaceDim,
          name: 'surfaceDim',
        ),
        _ColorBox(
          color: colors.surfaceBright,
          name: 'surfaceBright',
        ),
        _ColorBox(
          color: colors.surfaceContainerLowest,
          name: 'surfaceContainerLowest',
        ),
        _ColorBox(
          color: colors.surfaceContainerLow,
          name: 'surfaceContainerLow',
        ),
        _ColorBox(
          color: colors.surfaceContainer,
          name: 'surfaceContainer',
        ),
        _ColorBox(
          color: colors.surfaceContainerHigh,
          name: 'surfaceContainerHigh',
        ),
        _ColorBox(
          color: colors.surfaceContainerHighest,
          name: 'surfaceContainerHighest',
        ),
        _ColorBox(
          color: colors.onSurfaceVariant,
          name: 'onSurfaceVariant',
        ),
        _ColorBox(
          color: colors.outline,
          name: 'outline',
        ),
        _ColorBox(
          color: colors.outlineVariant,
          name: 'outlineVariant',
        ),
        _ColorBox(
          color: colors.shadow,
          name: 'shadow',
        ),
        _ColorBox(
          color: colors.scrim,
          name: 'scrim',
        ),
        _ColorBox(
          color: colors.inverseSurface,
          name: 'inverseSurface',
        ),
        _ColorBox(
          color: colors.onInverseSurface,
          name: 'onInverseSurface',
        ),
        _ColorBox(
          color: colors.inversePrimary,
          name: 'inversePrimary',
        ),
        _ColorBox(
          color: colors.surfaceTint,
          name: 'surfaceTint',
        ),
      ],
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({required this.color, required this.name});

  final Color color;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 100),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: color, border: Border.all()),
            width: 100,
            height: 100,
          ),
          Text(name),
        ],
      ),
    );
  }
}

class ThemeModeSwitch extends ConsumerWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    return DropdownButton<ThemeMode>(
      value: themeMode,
      onChanged: (value) {
        if (value == null) return;
        ref.read(themeModeNotifierProvider.notifier).setThemeMode(value);
      },
      items: [
        for (final mode in ThemeMode.values)
          DropdownMenuItem(
            value: mode,
            child: Text(mode.toString()),
          ),
      ],
    );
  }
}
