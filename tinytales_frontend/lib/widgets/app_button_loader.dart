import 'package:flutter/material.dart';

/// Intended to be used as a loading indicator for buttons.
/// Pass it as icon to button
/// (e.g. `FilledButton.icon(icon: const AppButtonLoader(), ...)`.
class AppButtonLoader extends StatelessWidget {
  const AppButtonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(strokeWidth: 3),
    );
  }
}
