import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/debug/firebase.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/debug/theme.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';
import 'package:talker_flutter/talker_flutter.dart';

void showDebugMenu(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (context) => const DebugMenu(),
    ),
  );
}

class DebugMenu extends ConsumerWidget {
  const DebugMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Menu'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logs & Errors'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) {
                      return TalkerScreen(talker: ref.watch(talkerProvider));
                    },
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Throw test exception'),
              onTap: () => throw Exception('Test exception'),
            ),
            const FirebaseFunctionTest(),
            const FirebaseEmulatorSettings(
              emulatorName: 'Functions',
              hostKey: firebaseFunctionsEmulatorHostKey,
              portKey: firebaseFunctionsEmulatorPortKey,
            ),
            const FirebaseEmulatorSettings(
              emulatorName: 'Firestore',
              hostKey: firestoreEmulatorHostKey,
              portKey: firestoreEmulatorPortKey,
            ),
            ListTile(
              title: const Text('Theme Showcase'),
              onTap: () => showThemeShowcase(context),
            ),
            const ListTile(
              title: Text('Theme Mode'),
              trailing: ThemeModeSwitch(),
            ),
            ListTile(
              title: const Text('Story create - loader'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => Scaffold(
                    appBar: AppBar(),
                    body: const StoryCreateLoader(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
