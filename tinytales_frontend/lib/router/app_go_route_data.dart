import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// AppGoRouteData is a custom GoRouteData that disables transitions on web.
/// Use it on all routes to properly support all platforms.
class AppGoRouteData extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    if (kIsWeb) {
      // No transition on web by default
      return NoTransitionPage(child: build(context, state));
    } else {
      return super.buildPage(context, state);
    }
  }
}

/// Always builds a page with no transition.
class NoTransitionRouteData extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(child: build(context, state));
  }
}

/// Same purpose as [AppGoRouteData] but for shell routes.]
class AppShellRouteData extends ShellRouteData {
  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    if (kIsWeb) {
      // No transition on web by default
      return NoTransitionPage(child: builder(context, state, navigator));
    } else {
      return super.pageBuilder(context, state, navigator);
    }
  }
}
