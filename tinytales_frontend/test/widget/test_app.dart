import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/auth_guard.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

/// Use it when you only want to test part of the screen
/// or screen without navigation
class TestAppWidget extends StatelessWidget {
  const TestAppWidget({
    required this.child,
    this.overrides = const [],
    this.locale = const Locale('en'),
    super.key,
  });

  final Widget child;
  final List<Override> overrides;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = Theme.of(context).textTheme;
    final appTheme = AppTheme(textTheme: baseTextTheme);
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: appTheme.light(),
        darkTheme: appTheme.dark(),
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: ResponsiveBreakpoints(
          breakpoints: appBreakpoints,
          child: Material(
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Use it to setup tests that require routing/navigation
class TestApp extends StatelessWidget {
  const TestApp({
    this.defaultRoute,
    this.overrides = const [],
    this.locale = const Locale('en'),
    super.key,
  });

  final String? defaultRoute;
  final List<Override> overrides;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: _AppWithRouter(
        defaultRoute: defaultRoute,
        overrides: overrides,
        locale: locale,
      ),
    );
  }
}

class _AppWithRouter extends HookConsumerWidget {
  const _AppWithRouter({
    this.defaultRoute,
    this.overrides = const [],
    this.locale = const Locale('en'),
  });

  final String? defaultRoute;
  final List<Override> overrides;
  final Locale locale;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = useMemoized(
      () => createRouter(
        initialLocation: defaultRoute,
        authGuard: (context, state) => authGuard(
          context,
          state,
          isLoggedIn: ref.read(isLoggedInProvider),
        ),
        refreshListenable: ref.watch(listenToAuthStateChangeProvider),
        observers: [],
      ),
      [],
    );

    final baseTextTheme = Theme.of(context).textTheme;
    final appTheme = AppTheme(textTheme: baseTextTheme);
    return MaterialApp.router(
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
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
