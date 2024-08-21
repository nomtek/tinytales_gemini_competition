import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

const pageAnimationDuration = Duration(milliseconds: 200);
const pageAnimationCurve = Curves.easeInOut;

class FormStepHeader extends StatelessWidget {
  const FormStepHeader({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final paddingValue = ResponsiveValue(
      context,
      conditionalValues: [
        const Condition.equals(
          name: DESKTOP,
          value: EdgeInsets.only(bottom: 48),
        ),
      ],
      defaultValue: const EdgeInsets.only(bottom: 32),
    ).value;

    return AnimatedPadding(
      duration: Durations.short2,
      padding: paddingValue,
      child: Column(
        children: [
          HeadlineSmallText(title: title),
          if (subtitle != null) ...[
            const Gap(8),
            Text(
              subtitle ?? '',
              style: context.textTheme.titleSmall!.copyWith(
                color: context.colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class StepLoading extends StatelessWidget {
  const StepLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.surfaceContainerHigh,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ErrorText extends StatelessWidget {
  const ErrorText({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.textTheme.bodySmall!.copyWith(
        color: context.colors.error,
      ),
    );
  }
}

class WarningText extends StatelessWidget {
  const WarningText({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: context.textTheme.bodySmall!.copyWith(
        color: context.customColors.warning,
      ),
    );
  }
}

@immutable
class SingleSelectionListItem extends Equatable {
  const SingleSelectionListItem({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  List<Object?> get props => [title, description];
}

class SingleSelectionList extends StatelessWidget {
  const SingleSelectionList({
    required this.items,
    required this.currentValue,
    required this.onChanged,
    super.key,
  });

  final List<SingleSelectionListItem> items;
  final SingleSelectionListItem? currentValue;
  final ValueChanged<SingleSelectionListItem?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppListContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in items) ...[
            RadioListTile(
              key: Key(item.title),
              isThreeLine: true,
              value: item,
              title: Text(
                item.title,
                style: context.textTheme.bodyLarge,
              ),
              subtitle: Text(
                item.description,
                style: context.textTheme.bodyMedium,
              ),
              groupValue: currentValue,
              // isThreeLine: true,
              onChanged: onChanged,
            ),
            if (item != items.last) const Divider(),
          ],
        ],
      ),
    );
  }
}

class CustomStepTile extends ConsumerWidget {
  const CustomStepTile({
    required this.title,
    required this.onClicked,
    super.key,
  });

  final String title;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppListContainer(
      child: ListTile(
        title: Text(
          title,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        trailing: const Icon(Icons.arrow_right),
        tileColor: context.colors.surface,
        onTap: onClicked,
      ),
    );
  }
}
