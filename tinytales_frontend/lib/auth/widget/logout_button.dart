import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_service.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        // simple solution as we don't have any specific logic for logout
        // and ui that should be affected by it
        ref.read(authServiceProvider).logout().catchError(
          (dynamic error, StackTrace st) {
            if (!context.mounted) return;
            ref.read(talkerProvider).error('Error during logout', error, st);
            final logoutFailedSnackbar = SnackBar(
              content: Text(context.l10n.logoutError),
            );
            ScaffoldMessenger.of(context).showSnackBar(logoutFailedSnackbar);
          },
        );
      },
      child: Text(context.l10n.logout),
    );
  }
}
