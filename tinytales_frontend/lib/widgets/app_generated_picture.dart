import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/app_progress_indicator.dart';

enum AppGeneratedPictureSize {
  small(56),
  large(220);

  const AppGeneratedPictureSize(this.size);
  final double size;
}

enum AppGeneratedPictureState {
  generating,
  generationCompleted,
  error,
}

class AppLargeGeneratedPicture extends StatelessWidget {
  const AppLargeGeneratedPicture({
    required this.pictureState,
    required this.pictureUrl,
    super.key,
  });

  final String? pictureUrl;
  final AppGeneratedPictureState pictureState;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppGeneratedPictureSize.large.size,
      child: AppGeneratedPicture(
        pictureUrl: pictureUrl,
        pictureState: pictureState,
      ),
    );
  }
}

class AppSmallGeneratedPicture extends StatelessWidget {
  const AppSmallGeneratedPicture({
    required this.pictureState,
    required this.pictureUrl,
    super.key,
  });

  final String? pictureUrl;
  final AppGeneratedPictureState pictureState;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppGeneratedPictureSize.small.size,
      child: AppGeneratedPicture(
        pictureUrl: pictureUrl,
        pictureState: pictureState,
      ),
    );
  }
}

class AppGeneratedPicture extends StatelessWidget {
  const AppGeneratedPicture({
    required this.pictureUrl,
    required this.pictureState,
    super.key,
  });

  final String? pictureUrl;
  final AppGeneratedPictureState pictureState;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: switch (pictureState) {
        AppGeneratedPictureState.generating =>
          const _GeneratedPicturePlaceholder(),
        AppGeneratedPictureState.generationCompleted => _GeneratedPictureData(
            url: pictureUrl,
          ),
        AppGeneratedPictureState.error => const _GeneratedPictureError()
      },
    );
  }
}

class _GeneratedPictureData extends ConsumerWidget {
  const _GeneratedPictureData({
    required this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageContent = url != null
        ? Image.network(
            url!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              ref.read(talkerProvider).error(error, stackTrace);
              return const _GeneratedPictureError();
            },
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const _GeneratedPicturePlaceholder(),
          )
        : const _GeneratedPicturePlaceholder();

    return ClipRRect(
      borderRadius: context.dimensions.borderRadius,
      child: imageContent,
    );
  }
}

class _GeneratedPicturePlaceholder extends StatelessWidget {
  const _GeneratedPicturePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: context.dimensions.borderRadius,
      child: ColoredBox(
        color: context.colors.surfaceContainerHighest,
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: AppCircularProgressIndicator(
              strokeWidth: 3,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneratedPictureError extends StatelessWidget {
  const _GeneratedPictureError();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_not_supported_outlined,
      size: 24,
      color: context.colors.onSurfaceVariant,
    );
  }
}
