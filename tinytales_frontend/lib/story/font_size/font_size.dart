import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/persistance/shared_prefs_provider.dart';

part 'font_size.g.dart';

// These values are used as font sizes
// for the text in the story.
// Can be adjusted later if those values are not suitable.
enum StoryTextSize {
  small(12),
  regular(14),
  large(16);

  const StoryTextSize(this.fontSize);

  factory StoryTextSize.fromString(String? value) {
    switch (value) {
      case 'StoryTextSize.small':
        return StoryTextSize.small;
      case 'StoryTextSize.regular':
        return StoryTextSize.regular;
      case 'StoryTextSize.large':
        return StoryTextSize.large;
      default:
        return StoryTextSize.regular;
    }
  }

  /// Font size in logical points. Check [TextStyle.fontSize].
  final double fontSize;
}

extension StoryTextSizeExtension on StoryTextSize {
  String label(BuildContext context) {
    switch (this) {
      case StoryTextSize.small:
        return context.l10n.storyPageFontSizeSmall;
      case StoryTextSize.regular:
        return context.l10n.storyPageFontSizeRegular;
      case StoryTextSize.large:
        return context.l10n.storyPageFontSizeLarge;
    }
  }

  String a11yLabel(BuildContext context) {
    switch (this) {
      case StoryTextSize.small:
        return context.l10n.storyPageFontSizeSmallA11y;
      case StoryTextSize.regular:
        return context.l10n.storyPageFontSizeRegularA11y;
      case StoryTextSize.large:
        return context.l10n.storyPageFontSizeLargeA11y;
    }
  }
}

@riverpod
class StoryTextSizeNotifier extends _$StoryTextSizeNotifier {
  static const _prefsKey = 'story_text_size';

  @override
  StoryTextSize build() {
    return StoryTextSize.fromString(
      ref.read(sharedPreferencesProvider).getString(_prefsKey),
    );
  }

  Future<void> changeFontSize(StoryTextSize size) async {
    state = size;
    await ref
        .read(sharedPreferencesProvider)
        .setString(_prefsKey, size.toString());
  }
}
