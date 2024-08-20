import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@visibleForTesting
final progressValueProvider = StateProvider<double?>((ref) => null);

class AppCircularProgressIndicator extends ConsumerWidget {
  const AppCircularProgressIndicator({
    super.key,
    this.value,
    this.strokeWidth = 4.0,
    this.color,
  });

  final double strokeWidth;
  final Color? color;
  final double? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressValue = value ?? ref.watch(progressValueProvider);

    return CircularProgressIndicator(
      value: progressValue,
      strokeWidth: strokeWidth,
      color: color,
    );
  }
}
