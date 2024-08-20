import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class HeadlineSmallText extends StatelessWidget {
  const HeadlineSmallText({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      title,
      style: context.textTheme.headlineSmall!.copyWith(
        color: context.colors.primary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
