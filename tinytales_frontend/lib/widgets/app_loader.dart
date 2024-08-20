import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';

/// A widget that shows a loading indicator.
class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loading,
      child: const CircularProgressIndicator(),
    );
  }
}
