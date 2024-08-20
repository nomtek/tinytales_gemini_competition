// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeShellRoute,
      $loginRoute,
    ];

RouteBase get $homeShellRoute => ShellRouteData.$route(
      navigatorKey: HomeShellRoute.$navigatorKey,
      factory: $HomeShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/',
          name: 'home',
          factory: $HomeRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'story-creator',
              name: 'story-creator',
              parentNavigatorKey: StoryCreatorRoute.$parentNavigatorKey,
              factory: $StoryCreatorRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'freeform',
              name: 'freeform',
              parentNavigatorKey: FreeformPageRoute.$parentNavigatorKey,
              factory: $FreeformPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'story/:storyId',
              name: 'story',
              parentNavigatorKey: StoryPageRoute.$parentNavigatorKey,
              factory: $StoryPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'next-adventure-proposals',
                  name: 'next-adventure-proposals',
                  parentNavigatorKey:
                      NextAdventureProposalsRoute.$parentNavigatorKey,
                  factory: $NextAdventureProposalsRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/history',
          name: 'history',
          factory: $HistoryPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'story/:storyId',
              name: 'story-from-history',
              parentNavigatorKey: HistoryToStoryPageRoute.$parentNavigatorKey,
              factory: $HistoryToStoryPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/characters',
          name: 'characters',
          factory: $CharactersPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'edit-character/:characterId',
              name: 'edit-character',
              factory: $EditCharacterPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'create-character',
              name: 'create-character',
              factory: $CreateCharacterPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/settings',
          name: 'settings',
          factory: $SettingsPageRouteExtension._fromState,
        ),
      ],
    );

extension $HomeShellRouteExtension on HomeShellRoute {
  static HomeShellRoute _fromState(GoRouterState state) => HomeShellRoute();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $StoryCreatorRouteExtension on StoryCreatorRoute {
  static StoryCreatorRoute _fromState(GoRouterState state) =>
      StoryCreatorRoute();

  String get location => GoRouteData.$location(
        '/story-creator',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FreeformPageRouteExtension on FreeformPageRoute {
  static FreeformPageRoute _fromState(GoRouterState state) =>
      FreeformPageRoute();

  String get location => GoRouteData.$location(
        '/freeform',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $StoryPageRouteExtension on StoryPageRoute {
  static StoryPageRoute _fromState(GoRouterState state) => StoryPageRoute(
        storyId: state.pathParameters['storyId']!,
      );

  String get location => GoRouteData.$location(
        '/story/${Uri.encodeComponent(storyId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NextAdventureProposalsRouteExtension on NextAdventureProposalsRoute {
  static NextAdventureProposalsRoute _fromState(GoRouterState state) =>
      NextAdventureProposalsRoute(
        storyId: state.pathParameters['storyId']!,
      );

  String get location => GoRouteData.$location(
        '/story/${Uri.encodeComponent(storyId)}/next-adventure-proposals',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $HistoryPageRouteExtension on HistoryPageRoute {
  static HistoryPageRoute _fromState(GoRouterState state) => HistoryPageRoute();

  String get location => GoRouteData.$location(
        '/history',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $HistoryToStoryPageRouteExtension on HistoryToStoryPageRoute {
  static HistoryToStoryPageRoute _fromState(GoRouterState state) =>
      HistoryToStoryPageRoute(
        storyId: state.pathParameters['storyId']!,
      );

  String get location => GoRouteData.$location(
        '/history/story/${Uri.encodeComponent(storyId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CharactersPageRouteExtension on CharactersPageRoute {
  static CharactersPageRoute _fromState(GoRouterState state) =>
      CharactersPageRoute();

  String get location => GoRouteData.$location(
        '/characters',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditCharacterPageRouteExtension on EditCharacterPageRoute {
  static EditCharacterPageRoute _fromState(GoRouterState state) =>
      EditCharacterPageRoute(
        characterId: state.pathParameters['characterId']!,
        name: state.uri.queryParameters['name']!,
        description: state.uri.queryParameters['description'],
      );

  String get location => GoRouteData.$location(
        '/characters/edit-character/${Uri.encodeComponent(characterId)}',
        queryParams: {
          'name': name,
          if (description != null) 'description': description,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreateCharacterPageRouteExtension on CreateCharacterPageRoute {
  static CreateCharacterPageRoute _fromState(GoRouterState state) =>
      CreateCharacterPageRoute();

  String get location => GoRouteData.$location(
        '/characters/create-character',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsPageRouteExtension on SettingsPageRoute {
  static SettingsPageRoute _fromState(GoRouterState state) =>
      SettingsPageRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      name: 'login',
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
