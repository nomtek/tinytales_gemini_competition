import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/debug/firebase.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/device/device.dart';
import 'package:tale_ai_frontend/env/env.dart';
import 'package:tale_ai_frontend/firebase_options.dart';
import 'package:tale_ai_frontend/gen/assets.gen.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/persistance/shared_prefs_provider.dart';
import 'package:tale_ai_frontend/router/auth_guard.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/theme/theme_mode.dart';
import 'package:tale_ai_frontend/user/user_service.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';

part 'main.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();
  await _setupFirebase(sharedPrefs);

  // make sure urls are updating when using context.push
  GoRouter.optionURLReflectsImperativeAPIs = true;

  _registerLicenses();

  runApp(
    ProviderScope(
      observers: [
        TalkerRiverpodObserver(
          talker: talkerInstance,
          // ignore: avoid_redundant_argument_values
          settings: const TalkerRiverpodLoggerSettings(
            // ignore: avoid_redundant_argument_values
            enabled: !kIsProd,
          ),
        ),
      ],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _setupFirebase(
  SharedPreferences sharedPrefs,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsProd) {
    final functionsEmulatorHost =
        const bool.hasEnvironment(firebaseFunctionsEmulatorHostKey)
            ? const String.fromEnvironment(firebaseFunctionsEmulatorHostKey)
            : sharedPrefs.getString(firebaseFunctionsEmulatorHostKey);

    final functionsEmulatorPort =
        const bool.hasEnvironment(firebaseFunctionsEmulatorPortKey)
            ? const int.fromEnvironment(firebaseFunctionsEmulatorPortKey)
            : sharedPrefs.getInt(firebaseFunctionsEmulatorPortKey);

    if (functionsEmulatorHost != null && functionsEmulatorPort != null) {
      debugPrint('Found Firebase Functions emulator settings.');
      debugPrint(
        'Setting up Firebase emulators on '
        '$functionsEmulatorHost:$functionsEmulatorPort.',
      );
      FirebaseFunctions.instance.useFunctionsEmulator(
        functionsEmulatorHost,
        functionsEmulatorPort,
      );
    }

    final firestoreEmulatorHost =
        const bool.hasEnvironment(firestoreEmulatorHostKey)
            ? const String.fromEnvironment(firestoreEmulatorHostKey)
            : sharedPrefs.getString(firestoreEmulatorHostKey);

    final firestoreEmulatorPort =
        const bool.hasEnvironment(firestoreEmulatorPortKey)
            ? const int.fromEnvironment(firestoreEmulatorPortKey)
            : sharedPrefs.getInt(firestoreEmulatorPortKey);

    if (firestoreEmulatorHost != null && firestoreEmulatorPort != null) {
      debugPrint('Found Firestore emulator settings.');
      debugPrint(
        'Setting up Firestore emulator on '
        '$firestoreEmulatorHost:$firestoreEmulatorPort.',
      );
      FirebaseFirestore.instance.useFirestoreEmulator(
        firestoreEmulatorHost,
        firestoreEmulatorPort,
      );
    }
  }

  if (!kIsWeb && !kDebugMode) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Pass all uncaught asynchronous errors that aren't handled by
    // the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}

void _registerLicenses() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(Assets.fonts.inter.ofl);
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(Assets.fonts.sniglet.ofl);
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = useMemoized(
      () => createRouter(
        authGuard: (context, state) => authGuard(
          context,
          state,
          isLoggedIn: ref.read(isLoggedInProvider),
        ),
        refreshListenable: ref.watch(listenToAuthStateChangeProvider),
        observers: [ref.watch(talkerRouteObserverProvider)],
      ),
      [],
    );

    // listen to the device locale changes and update the user locale
    useOnDeviceLocaleChanged(() => ref.invalidate(deviceLocaleProvider));
    ref.listen(setUserLocaleProvider, (_, __) {});

    final baseTextTheme = Theme.of(context).textTheme;
    final appTheme = AppTheme(textTheme: baseTextTheme);
    return MaterialApp.router(
      title: 'Tinytales',
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      themeMode: ref.watch(themeModeNotifierProvider),
      routerConfig: router,
      locale: ref.watch(deviceLocaleProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: ColoredBox(
          color: context.colors.surfaceContainerHighest,
          child: child,
        ),
        breakpoints: appBreakpoints,
      ),
    );
  }
}

// listen to the user auth changes and device locale changes
// and update the user locale
@riverpod
void setUserLocale(SetUserLocaleRef ref) {
  final userId = ref.watch(userIdProvider);
  final deviceLocale = ref.watch(deviceLocaleProvider);
  if (userId == null) {
    ref.read(talkerProvider).debug(
          'Aborting setUserLocale: user not logged in.',
        );
    return;
  }
  ref.read(userServiceProvider).setUserLocale(locale: deviceLocale);
}
