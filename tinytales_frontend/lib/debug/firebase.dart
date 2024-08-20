import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/persistance/shared_prefs_provider.dart';

const firebaseFunctionsEmulatorHostKey = 'FIREBASE_FUNCTIONS_EMULATOR_HOST';
const firebaseFunctionsEmulatorPortKey = 'FIREBASE_FUNCTIONS_EMULATOR_PORT';
const firestoreEmulatorHostKey = 'FIREBASE_FIRESTORE_EMULATOR_HOST';
const firestoreEmulatorPortKey = 'FIREBASE_FIRESTORE_EMULATOR_PORT';

class FirebaseEmulatorSettings extends HookConsumerWidget {
  const FirebaseEmulatorSettings({
    required this.emulatorName,
    required this.hostKey,
    required this.portKey,
    super.key,
  });

  final String emulatorName;
  final String hostKey;
  final String portKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedPrefs = ref.watch(sharedPreferencesProvider);
    final initialHost = useMemoized(() {
      return sharedPrefs.getString(hostKey) ?? '';
    });
    final initialPort = useMemoized(() {
      return sharedPrefs.getInt(portKey)?.toString() ?? '';
    });
    final hostController = useTextEditingController(text: initialHost);
    final portController = useTextEditingController(text: initialPort);
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final onDataChanged = useMemoized(
      () => () {
        if (!formKey.currentState!.validate()) {
          return;
        }
        final host = hostController.text;
        final port = int.tryParse(portController.text);
        if (port == null && portController.text.isNotEmpty) {
          return;
        }
        debugPrint(
          'Firebase $emulatorName emulator settings changed: $host:$port',
        );
        if (host.isEmpty) {
          sharedPrefs.remove(hostKey);
        } else {
          sharedPrefs.setString(hostKey, host);
        }
        if (port != null) {
          sharedPrefs.setInt(portKey, port);
        } else {
          sharedPrefs.remove(portKey);
        }
      },
    );

    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          'Firebase $emulatorName emulator settings',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      subtitle: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const Text(
              'Remember to restart the app after changing the settings.',
            ),
            const Gap(8),
            TextFormField(
              controller: hostController,
              decoration: const InputDecoration(
                labelText: 'Host (IP address)',
                hintText: 'localhost or 0.0.0.0',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value == 'localhost') {
                    return null;
                  }
                  final validHostRegex = RegExp(
                    r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
                  );
                  final isIp = validHostRegex.hasMatch(value);
                  if (!isIp) {
                    return 'Invalid IP address (0.0.0.0)';
                  }
                }
                return null;
              },
              onChanged: (_) => onDataChanged(),
              textInputAction: TextInputAction.next,
            ),
            const Gap(8),
            TextFormField(
              controller: portController,
              decoration: const InputDecoration(
                labelText: 'Port',
                hintText: '5001',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final validPortRegex = RegExp(
                    r'^(102[4-9]|10[3-9]\d|1[1-9]\d{2}|[2-9]\d{3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$',
                  );
                  final isPort = validPortRegex.hasMatch(value);
                  if (!isPort) {
                    return 'Invalid port number (1024-65535)';
                  }
                }
                return null;
              },
              onChanged: (_) => onDataChanged(),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}

// runs a test cloud function
class FirebaseFunctionTest extends StatelessWidget {
  const FirebaseFunctionTest({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Firebase cloud function test'),
      onTap: () async {
        final functions = FirebaseFunctions.instance;
        final result = await functions
            .httpsCallable('addCharacter')
            .call<dynamic>({'name': 'test'});
        if (kDebugMode) {
          print(result.data);
        }
      },
    );
  }
}
