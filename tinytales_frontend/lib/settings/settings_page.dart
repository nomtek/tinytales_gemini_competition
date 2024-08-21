import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tale_ai_frontend/auth/widget/logout_button.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/theme/theme_mode.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsPageTitle),
      ),
      body: const AppMaxContentWidth(
        child: AppScrollableContentScaffold(
          scrollableContent: Column(
            children: [
              _DarkTheme(),
              _Licenses(),
            ],
          ),
          bottomContent: Column(
            children: [
              _AppVersion(),
              PageHorizontalPadding(
                child: AppButtonBar(
                  primaryButton: LogoutButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkTheme extends ConsumerWidget {
  const _DarkTheme();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeNotifierProvider);
    final themeText = switch (themeMode) {
      ThemeMode.system => context.l10n.systemDefault,
      ThemeMode.light => context.l10n.lightTheme,
      ThemeMode.dark => context.l10n.darkTheme,
    };

    return ListTile(
      title: Text(context.l10n.theme),
      subtitle: Text(themeText),
      onTap: () {
        _showThemeSelectionDialog(
          context: context,
          initialThemeMode: themeMode,
        ).then((selectedThemeMode) {
          if (selectedThemeMode != null && context.mounted) {
            ref.read(themeModeNotifierProvider.notifier).setThemeMode(
                  selectedThemeMode,
                );
          }
        });
      },
      trailing: const Icon(Icons.arrow_right),
    );
  }
}

Future<ThemeMode?> _showThemeSelectionDialog({
  required BuildContext context,
  required ThemeMode initialThemeMode,
}) async {
  return showDialog<ThemeMode>(
    context: context,
    builder: (context) {
      return _ThemeDialog(initialThemeMode: initialThemeMode);
    },
  );
}

class _ThemeDialog extends HookWidget {
  const _ThemeDialog({
    required this.initialThemeMode,
  });
  final ThemeMode initialThemeMode;
  @override
  Widget build(BuildContext context) {
    final selectedThemeMode = useState(initialThemeMode);

    return AlertDialog(
      title: Text(context.l10n.chooseTheme),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            title: Text(context.l10n.systemDefault),
            value: ThemeMode.system,
            groupValue: selectedThemeMode.value,
            onChanged: (value) {
              if (value != null) {
                selectedThemeMode.value = value;
              }
            },
          ),
          RadioListTile(
            title: Text(context.l10n.lightTheme),
            value: ThemeMode.light,
            groupValue: selectedThemeMode.value,
            onChanged: (value) {
              if (value != null) {
                selectedThemeMode.value = value;
              }
            },
          ),
          RadioListTile(
            title: Text(context.l10n.darkTheme),
            value: ThemeMode.dark,
            groupValue: selectedThemeMode.value,
            onChanged: (value) {
              if (value != null) {
                selectedThemeMode.value = value;
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, selectedThemeMode.value),
          child: Text(context.l10n.ok),
        ),
      ],
    );
  }
}

class _AppVersion extends HookWidget {
  const _AppVersion();

  @override
  Widget build(BuildContext context) {
    final future = useMemoized(PackageInfo.fromPlatform);
    final packageInfo = useFuture(future);
    final appVer = packageInfo.data?.version;
    final buildNumber = packageInfo.data?.buildNumber;
    final fullAppVer =
        appVer != null && buildNumber != null ? '$appVer ($buildNumber)' : '-';

    return Column(
      children: [
        Text(
          context.l10n.settingsPageAppVersion,
          style: context.textTheme.bodyLarge!.copyWith(
            color: context.colors.primary,
          ),
        ),
        Text(
          fullAppVer,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colors.primary,
          ),
        ),
      ],
    );
  }
}

class _Licenses extends StatelessWidget {
  const _Licenses();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(MaterialLocalizations.of(context).licensesPageTitle),
      onTap: () => showLicensePage(
        context: context,
        applicationName: context.l10n.appName,
        useRootNavigator: true,
      ),
      trailing: const Icon(Icons.arrow_right),
    );
  }
}
