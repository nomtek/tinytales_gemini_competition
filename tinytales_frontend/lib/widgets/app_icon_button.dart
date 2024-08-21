import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isSelected,
    this.selectedIcon,
    super.key,
  });

  final VoidCallback? onPressed;

  final Widget icon;

  final String? tooltip;

  final bool? isSelected;

  final Widget? selectedIcon;

  @override
  Widget build(BuildContext context) {
    // We are overwriting semantics so VoiceOver and Talkback are reading
    // label same way on both platforms.
    return Semantics(
      button: true,
      label: tooltip,
      enabled: onPressed != null,
      selected: isSelected,
      child: ExcludeSemantics(
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
          isSelected: isSelected,
          selectedIcon: selectedIcon,
        ),
      ),
    );
  }
}
