import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class FormError extends StatelessWidget {
  const FormError({
    required this.onTryAgain,
    required this.onClose,
    super.key,
  });

  final VoidCallback onTryAgain;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      onTryAgain: onTryAgain,
      onClose: onClose,
    );
  }
}
