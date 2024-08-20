import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

FutureOr<String?> authGuard(
  BuildContext context,
  GoRouterState state, {
  required bool isLoggedIn,
}) {
  // go to login if not logged in
  if (!isLoggedIn) {
    return '/login';
  }

  // if just logged in then go to home
  if (state.fullPath == '/login' && isLoggedIn) {
    return '/';
  }

  // Allow the route
  return null;
}
