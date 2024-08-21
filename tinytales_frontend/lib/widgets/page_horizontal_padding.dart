import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class PageHorizontalPadding extends StatelessWidget {
  const PageHorizontalPadding({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.dimensions.pageHorizontalPadding,
      ),
      child: child,
    );
  }
}
