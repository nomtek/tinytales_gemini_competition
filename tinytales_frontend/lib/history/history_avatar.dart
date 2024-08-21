import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/story/data/data.dart';
import 'package:tale_ai_frontend/story/providers.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'history_avatar.g.dart';

// We need to observe the character image link in order to display the change
// in the UI when the user image is generated. Currently, the image is displayed
// in lists where characters are downloaded once and not updated after that.
// There is potential for performance improvements here
@riverpod
Stream<String?> _storyPictureUrl(
  _StoryPictureUrlRef ref,
  String storyId,
) async* {
  final firestore = ref.watch(firestoreProvider);
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    throw StateError('User is not logged in');
  }
  final storyDoc = firestore.storyDocRef(userId: userId, storyId: storyId);
  final storyStream = storyDoc.snapshots().map((snapshot) => snapshot.data());
  yield* storyStream.map((story) => story?.picture);
}

class HistoryAvatar extends ConsumerWidget {
  const HistoryAvatar({
    required this.storyId,
    super.key,
  });

  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyPictureUrl =
        ref.watch(_storyPictureUrlProvider(storyId)).valueOrNull;
    final storyPictureState = ref.watch(storyPictureStateProvider(storyId));
    return AppSmallGeneratedPicture(
      pictureUrl: storyPictureUrl,
      pictureState: storyPictureState,
    );
  }
}
