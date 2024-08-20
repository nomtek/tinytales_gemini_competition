import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';

class RegenerateButton extends HookWidget {
  const RegenerateButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final temporarilyDisabled = useState(false);
    useEffect(
      () {
        if (!temporarilyDisabled.value) return;
        // reset temporarily disabled state after some time
        Future.delayed(
          const Duration(milliseconds: 1250),
          () {
            if (!context.mounted) return;
            temporarilyDisabled.value = false;
          },
        );
        return null;
      },
      [temporarilyDisabled.value],
    );

    return TextButton.icon(
      label: Text(context.l10n.regeneratePicture),
      icon: const Icon(Icons.refresh_outlined),
      onPressed: onPressed != null && !temporarilyDisabled.value
          ? () {
              onPressed!();
              // disable button for some time to prevent spamming
              // and show feedback to user that something
              // is actually happening
              temporarilyDisabled.value = true;
            }
          : null,
    );
  }
}
