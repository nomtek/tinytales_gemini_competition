import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tale_ai_frontend/auth/login_page.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/freeform/freeform_page.dart';
import 'package:tale_ai_frontend/history/history_page.dart';
import 'package:tale_ai_frontend/home/home_page.dart';
import 'package:tale_ai_frontend/router/app_go_route_data.dart';
import 'package:tale_ai_frontend/settings/settings_page.dart';
import 'package:tale_ai_frontend/story/next_adventure_proposals.dart';
import 'package:tale_ai_frontend/story/story_page.dart';
import 'package:tale_ai_frontend/story_creator/story_creator_page.dart';
import 'package:tale_ai_frontend/widgets/nav_scaffold.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter({
  required List<NavigatorObserver> observers,
  required GoRouterRedirect authGuard,
  required Listenable refreshListenable,
  String? initialLocation,
}) =>
    GoRouter(
      initialLocation: initialLocation,
      routes: $appRoutes,
      navigatorKey: _rootNavigatorKey,
      refreshListenable: refreshListenable,
      redirect: authGuard,
      observers: observers,
    );

@TypedShellRoute<HomeShellRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(
      path: '/',
      name: 'home',
      routes: [
        TypedGoRoute<StoryCreatorRoute>(
          path: 'story-creator',
          name: 'story-creator',
        ),
        TypedGoRoute<FreeformPageRoute>(path: 'freeform', name: 'freeform'),
        TypedGoRoute<StoryPageRoute>(
          path: 'story/:storyId',
          name: 'story',
          routes: [
            TypedGoRoute<NextAdventureProposalsRoute>(
              path: 'next-adventure-proposals',
              name: 'next-adventure-proposals',
            ),
          ],
        ),
      ],
    ),
    TypedGoRoute<HistoryPageRoute>(
      path: '/history',
      name: 'history',
      routes: [
        TypedGoRoute<HistoryToStoryPageRoute>(
          path: 'story/:storyId',
          name: 'story-from-history',
        ),
      ],
    ),
    TypedGoRoute<CharactersPageRoute>(
      path: '/characters',
      name: 'characters',
      routes: [
        TypedGoRoute<EditCharacterPageRoute>(
          path: 'edit-character/:characterId',
          name: 'edit-character',
        ),
        TypedGoRoute<CreateCharacterPageRoute>(
          path: 'create-character',
          name: 'create-character',
        ),
      ],
    ),
    TypedGoRoute<SettingsPageRoute>(path: '/settings', name: 'settings'),
  ],
)
class HomeShellRoute extends AppShellRouteData {
  static final GlobalKey<NavigatorState> $navigatorKey = _shellNavigatorKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return NavScaffold(child: navigator);
  }
}

// No transistion always as it's a direct route of
// shell route and there is bug in Flutter related to that
// https://github.com/flutter/flutter/issues/139471
class HomeRoute extends NoTransitionRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomePage();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login', name: 'login')
class LoginRoute extends AppGoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginPage();
  }
}

class StoryCreatorRoute extends AppGoRouteData {
  // Without this static key, the dialog will not cover the bottom app bar.
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const StoryCreatorPage();
  }
}

class NextAdventureProposalsRoute extends AppGoRouteData {
  NextAdventureProposalsRoute({required this.storyId});
  // Without this static key, the dialog will not cover the bottom app bar.
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  final String storyId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NextAdventureProposals(
      storyId: storyId,
    );
  }
}

class FreeformPageRoute extends AppGoRouteData {
  // Without this static key, the dialog will not cover the bottom app bar.
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const FreeformPage();
  }
}

class StoryPageRoute extends AppGoRouteData {
  StoryPageRoute({required this.storyId});

  final String storyId;

  // Without this static key, the dialog will not cover the bottom app bar.
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StoryPage(storyId: storyId, isModal: true);
  }
}

// No transistion always as it's a direct route of
// shell route and there is bug in Flutter related to that
// https://github.com/flutter/flutter/issues/139471
class HistoryPageRoute extends NoTransitionRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HistoryPage();
  }
}

class HistoryToStoryPageRoute extends AppGoRouteData {
  HistoryToStoryPageRoute({required this.storyId});

  // Without this static key, the dialog will not cover the bottom app bar.
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      _rootNavigatorKey;

  final String storyId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return StoryPage(storyId: storyId);
  }
}

enum StoryPageCloseReason {
  delete,
}

// No transistion always as it's a direct route of
// shell route and there is bug in Flutter related to that
// https://github.com/flutter/flutter/issues/139471
class CharactersPageRoute extends NoTransitionRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CharactersPage();
  }
}

class EditCharacterPageRoute extends AppGoRouteData {
  EditCharacterPageRoute({
    required this.characterId,
    required this.name,
    this.description,
  });

  final String characterId;
  final String name;
  final String? description;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CharacterPage(
      mode: CharacterPageMode.edit,
      characterId: characterId,
      characterName: name,
      characterDescription: description,
    );
  }
}

class CreateCharacterPageRoute extends AppGoRouteData {
  CreateCharacterPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CharacterPage(
      mode: CharacterPageMode.create,
    );
  }
}

// No transition always as it's a direct route of
// shell route and there is bug in Flutter related to that
// https://github.com/flutter/flutter/issues/139471
class SettingsPageRoute extends NoTransitionRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsPage();
  }
}
