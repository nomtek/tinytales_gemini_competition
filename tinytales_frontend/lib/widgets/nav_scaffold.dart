import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/test_key_values.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';

class NavScaffold extends StatelessWidget {
  const NavScaffold({
    required this.child,
    this.selectedIndex,
    super.key,
  });

  final Widget child;

  /// selectedIndex is used to control the selected index of the bottom nav bar.
  /// If not provided, it will be calculated based on the current location.
  final int? selectedIndex;

  void onDestinationSelected(
    BuildContext context,
    int destination,
    int selectedIndex,
  ) {
    if (destination == selectedIndex) return;
    switch (destination) {
      case 0:
        HomeRoute().go(context);
      case 1:
        HistoryPageRoute().go(context);
      case 2:
        CharactersPageRoute().go(context);
      case 3:
        SettingsPageRoute().go(context);
      default:
        throw StateError(
          'Unhandled onDestinationSelected for destination at $destination',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Decides the index of the bottom nav bar.
    // If you change the order here you
    // need to change the order in the bottom nav bar destinations too,
    // and handle onDestinationSelected accordingly.
    final bottomNavRoutesLocations = {
      HomeRoute().location: 0,
      HistoryPageRoute().location: 1,
      CharactersPageRoute().location: 2,
      SettingsPageRoute().location: 3,
    };

    // Normalize the bottom nav routes locations to only the first path segment.
    // This is because the bottom nav only cares about the first path segment
    // because if we go to a nested route we still want to highlight
    // the parent route.
    final locationToIndex = {
      for (final entry in bottomNavRoutesLocations.entries)
        Uri.tryParse(entry.key)?.pathSegments.firstOrNull: entry.value,
    };

    final homeLocation =
        Uri.tryParse(HomeRoute().location)?.pathSegments.firstOrNull;

    late final int effectiveSelectedIndex;

    if (selectedIndex != null) {
      effectiveSelectedIndex = selectedIndex!;
    } else {
      final currentLocation =
          GoRouterState.of(context).uri.pathSegments.firstOrNull;
      effectiveSelectedIndex = locationToIndex[currentLocation] ??
          locationToIndex[homeLocation] ??
          0;
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    return screenWidth < 1024
        ? _BottomNavScaffold(
            selectedIndex: effectiveSelectedIndex,
            child: child,
            onDestinationSelected: (value) {
              onDestinationSelected(context, value, effectiveSelectedIndex);
            },
          )
        : _RailNavScaffold(
            selectedIndex: effectiveSelectedIndex,
            child: child,
            onDestinationSelected: (value) {
              onDestinationSelected(context, value, effectiveSelectedIndex);
            },
          );
  }
}

class _BottomNavScaffold extends StatelessWidget {
  const _BottomNavScaffold({
    required this.selectedIndex,
    required this.child,
    required this.onDestinationSelected,
  });

  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.home_outlined,
              key: TestKeyValues.bottomNavHomeKey,
            ),
            label: context.l10n.bottomNavHome,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.history_outlined,
              key: TestKeyValues.bottomNavHistoryKey,
            ),
            label: context.l10n.bottomNavHistory,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.person_outlined,
              key: TestKeyValues.bottomNavCharactersKey,
            ),
            label: context.l10n.bottomNavCharacters,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.settings_outlined,
              key: TestKeyValues.bottomNavSettingsKey,
            ),
            label: context.l10n.bottomNavSettings,
          ),
        ],
      ),
    );
  }
}

class _RailNavScaffold extends StatelessWidget {
  const _RailNavScaffold({
    required this.selectedIndex,
    required this.child,
    required this.onDestinationSelected,
  });

  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            // top padding
            leading: const SizedBox(height: 40),
            labelType: NavigationRailLabelType.all,
            backgroundColor: context.colors.surfaceContainerHigh,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(
                  Icons.home_outlined,
                  key: TestKeyValues.bottomNavHomeKey,
                ),
                label: Text(context.l10n.bottomNavHome),
              ),
              NavigationRailDestination(
                icon: const Icon(
                  Icons.history_outlined,
                  key: TestKeyValues.bottomNavHistoryKey,
                ),
                label: Text(context.l10n.bottomNavHistory),
              ),
              NavigationRailDestination(
                icon: const Icon(
                  Icons.person_outlined,
                  key: TestKeyValues.bottomNavCharactersKey,
                ),
                label: Text(context.l10n.bottomNavCharacters),
              ),
              NavigationRailDestination(
                icon: const Icon(
                  Icons.settings_outlined,
                  key: TestKeyValues.bottomNavSettingsKey,
                ),
                label: Text(context.l10n.bottomNavSettings),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          const VerticalDivider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
