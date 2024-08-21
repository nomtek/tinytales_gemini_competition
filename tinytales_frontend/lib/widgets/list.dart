import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

/// A container that wraps a list of items.
/// Designed to be used as a card.
/// Adds background, corner radius and elevation around child.
///
/// Works only on lists that are not scrollable.
/// For scrollable lists use [AppListTile]
class AppListContainer extends StatelessWidget {
  const AppListContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colors.surface,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// A list tile with custom styling.
/// Designed to be used in a list.
/// Based on isFirst and isLast - adds rounded corners
/// to the first and last tile.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.visualDensity,
    this.shape,
    this.style,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.leadingAndTrailingTextStyle,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.onFocusChange,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.titleAlignment,
    this.isFirst = false,
    this.isLast = false,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final bool? dense;
  final VisualDensity? visualDensity;
  final ShapeBorder? shape;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final ListTileStyle? style;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? leadingAndTrailingTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final ValueChanged<bool>? onFocusChange;
  final MouseCursor? mouseCursor;
  final bool selected;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? tileColor;
  final Color? selectedTileColor;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;
  final double? minTileHeight;
  final ListTileTitleAlignment? titleAlignment;

  // set those values to change the tile shape
  // based on position in the list.
  // first and last items has rounded corners
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final originalTheme = context.theme.listTileTheme;
    ListTileThemeData? effectiveTheme = originalTheme;

    if (isFirst && isLast) {
      effectiveTheme = originalTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: context.dimensions.borderRadius,
        ),
      );
    } else if (isFirst) {
      effectiveTheme = originalTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.dimensions.circleBorderRadius),
            topRight: Radius.circular(context.dimensions.circleBorderRadius),
          ),
        ),
      );
    } else if (isLast) {
      effectiveTheme = originalTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(context.dimensions.circleBorderRadius),
            bottomRight: Radius.circular(context.dimensions.circleBorderRadius),
          ),
        ),
      );
    }

    return ListTileTheme(
      data: effectiveTheme,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        isThreeLine: isThreeLine,
        dense: dense,
        visualDensity: visualDensity,
        shape: shape,
        style: style,
        selectedColor: selectedColor,
        iconColor: iconColor,
        textColor: textColor,
        titleTextStyle: titleTextStyle,
        subtitleTextStyle: subtitleTextStyle,
        leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
        contentPadding: contentPadding,
        enabled: enabled,
        onTap: onTap,
        onLongPress: onLongPress,
        onFocusChange: onFocusChange,
        mouseCursor: mouseCursor,
        selected: selected,
        focusColor: focusColor,
        hoverColor: hoverColor,
        splashColor: splashColor,
        focusNode: focusNode,
        autofocus: autofocus,
        tileColor: tileColor,
        selectedTileColor: selectedTileColor,
        enableFeedback: enableFeedback,
        horizontalTitleGap: horizontalTitleGap,
        minVerticalPadding: minVerticalPadding,
        minLeadingWidth: minLeadingWidth,
        minTileHeight: minTileHeight,
        titleAlignment: titleAlignment,
      ),
    );
  }
}

const _avatarSize = 56.0;

class ListTileNetworkAvatar extends ConsumerWidget {
  const ListTileNetworkAvatar({
    required this.url,
    super.key,
  });

  final String? url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageContent = url != null
        ? Image.network(
            url!,
            width: _avatarSize,
            height: _avatarSize,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const _ListTileAvatarPlaceholder(),
          )
        : const _ListTileAvatarPlaceholder();

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: context.dimensions.borderRadius,
        child: imageContent,
      ),
    );
  }
}

class _ListTileAvatarPlaceholder extends StatelessWidget {
  const _ListTileAvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      color: context.colors.surfaceContainerHighest,
      child: Center(
        child: SizedBox.square(
          dimension: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
