import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/characters/character_providers.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class ListCharacterAvatar extends ConsumerWidget {
  const ListCharacterAvatar({
    required this.characterId,
    super.key,
  });

  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterPictureUrl = ref
        .watch(observeCharacterPictureUrlProvider(characterId))
        .asData
        ?.value;

    final pictureState = ref.watch(characterPictureStateProvider(characterId));

    return AppSmallGeneratedPicture(
      pictureState: pictureState,
      pictureUrl: characterPictureUrl,
    );
  }
}
