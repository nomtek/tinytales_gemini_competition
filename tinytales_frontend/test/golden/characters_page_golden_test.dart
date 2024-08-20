import 'package:adaptive_test/adaptive_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../mock_services/mock_characters_service.dart';
import '../test_apps/golden_test_app.dart';
import '../test_data/character_test_data.dart';

void main() {
  final characters = [
    aCharacter(name: 'Gawcio'),
    aCharacter(name: 'Glipsiu'),
    aCharacter(name: 'Kinkpin'),
    aCharacter(name: 'Grulak'),
    aCharacter(name: 'Jesiok'),
  ];

  testAdaptiveWidgets('Characters page', (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          charactersServiceProvider.overrideWith(
            (ref) => MockCharactersService(characters: characters),
          ),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: NavScaffold(
              selectedIndex: 2,
              child: CharactersPage(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<CharactersPage>(
      windowConfig,
      suffix: 'list',
      waitForImages: false,
    );
  });

  testAdaptiveWidgets('Character details page', (tester, windowConfig) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isLoggedInProvider.overrideWithValue(true),
          charactersServiceProvider.overrideWith(
            (ref) => MockCharactersService(characters: characters),
          ),
        ],
        child: AdaptiveWrapper(
          windowConfig: windowConfig,
          tester: tester,
          child: const GoldenTestApp(
            child: CharacterPage(
              mode: CharacterPageMode.edit,
              characterId: 'id',
              characterDescription: 'description',
              characterName: 'name',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.expectGolden<CharacterPage>(
      windowConfig,
      suffix: 'details',
      waitForImages: false,
    );
  });
}
