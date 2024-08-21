import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

// Widget that plays audio from a URL
// with simple UI to control playback.
class UrlAudioPlayer extends HookWidget {
  const UrlAudioPlayer({
    required this.title,
    required this.audioUrl,
    required this.onClose,
    super.key,
  });

  final String audioUrl;
  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final player = useAudioPlayer(url: audioUrl);
    final durationValue = useStream(
      player.onDurationChanged,
      initialData: Duration.zero,
    );
    final positionValue = useStream(
      player.onPositionChanged,
      initialData: Duration.zero,
    );
    final playerState = useStream(
      player.onPlayerStateChanged,
      initialData: player.state,
    );
    final isPlaying = playerState.requireData == PlayerState.playing;

    return _Player(
      title: title,
      isPlaying: isPlaying,
      position: positionValue.requireData,
      duration: durationValue.requireData,
      onPlay: player.resume,
      onPause: player.pause,
      onClose: onClose,
      onGoBack10Seconds: () async {
        final currentPos = await player.getCurrentPosition();
        if (currentPos == null) return;
        if (currentPos.inSeconds < 10) {
          await player.seek(Duration.zero);
          return;
        }
        final newPos = currentPos - const Duration(seconds: 10);
        await player.seek(newPos);
      },
    );
  }
}

// Dummy audio player controls.
class _Player extends StatelessWidget {
  const _Player({
    required this.title,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.onPlay,
    required this.onPause,
    required this.onGoBack10Seconds,
    required this.onClose,
  });

  final String title;
  final Duration position;
  final Duration duration;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onGoBack10Seconds;
  final VoidCallback? onClose;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    String zeroPaddedNumber(int number) {
      return number.toString().padLeft(2, '0');
    }

    String timeText(int minutes, int seconds) {
      return '${zeroPaddedNumber(minutes)}:${zeroPaddedNumber(seconds)}';
    }

    final durationMinutes = duration.inMinutes.remainder(60);
    final durationSeconds = duration.inSeconds.remainder(60);
    final durationText = timeText(durationMinutes, durationSeconds);
    final positionMinutes = position.inMinutes.remainder(60);
    final positionSeconds = position.inSeconds.remainder(60);
    final positionText = timeText(positionMinutes, positionSeconds);

    final seekValue = duration == Duration.zero
        ? null
        : position.inMilliseconds / duration.inMilliseconds;

    return Semantics(
      container: true,
      label: context.l10n.audioPlayerStatus(
        isPlaying
            ? context.l10n.audioPlayerPlaying
            : context.l10n.audioPlayerPaused,
        positionMinutes,
        positionSeconds,
      ),
      child: Column(
        children: [
          ExcludeSemantics(
            child: LinearProgressIndicator(
              value: seekValue,
              backgroundColor: Colors.transparent,
              color: context.colors.onPrimaryContainer,
            ),
          ),
          if (context.isDesktopBreakpoint)
            _WidePlayerControls(
              title: title,
              positionText: positionText,
              durationText: durationText,
              isPlaying: isPlaying,
              onPause: onPause,
              onPlay: onPlay,
              onClose: onClose,
              onGoBack10Seconds: onGoBack10Seconds,
            )
          else
            _CompactPlayerControls(
              title: title,
              positionText: positionText,
              durationText: durationText,
              isPlaying: isPlaying,
              onPause: onPause,
              onPlay: onPlay,
              onGoBack10Seconds: onGoBack10Seconds,
            ),
        ],
      ),
    );
  }
}

class _CompactPlayerControls extends StatelessWidget {
  const _CompactPlayerControls({
    required this.title,
    required this.positionText,
    required this.durationText,
    required this.isPlaying,
    required this.onPause,
    required this.onPlay,
    required this.onGoBack10Seconds,
  });

  final String title;
  final String positionText;
  final String durationText;
  final bool isPlaying;
  final VoidCallback? onPause;
  final VoidCallback? onPlay;
  final VoidCallback? onGoBack10Seconds;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _AudioTitle(title: title),
      tileColor: context.colors.secondaryContainer,
      subtitle: _AudioDuration(
        positionText: positionText,
        durationText: durationText,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AudioPlayPauseButton(
            isPlaying: isPlaying,
            onPause: onPause,
            onPlay: onPlay,
          ),
          _AudioGoBackButton(onGoBack10Seconds: onGoBack10Seconds),
        ],
      ),
    );
  }
}

class _WidePlayerControls extends StatelessWidget {
  const _WidePlayerControls({
    required this.title,
    required this.positionText,
    required this.durationText,
    required this.isPlaying,
    this.onPause,
    this.onPlay,
    this.onGoBack10Seconds,
    this.onClose,
  });

  final String title;
  final String positionText;
  final String durationText;
  final bool isPlaying;
  final VoidCallback? onPause;
  final VoidCallback? onPlay;
  final VoidCallback? onGoBack10Seconds;
  final VoidCallback? onClose;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.secondaryContainer,
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 40,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AudioTitle(title: title),
                _AudioDuration(
                  positionText: positionText,
                  durationText: durationText,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AudioPlayPauseButton(
                  isPlaying: isPlaying,
                  onPause: onPause,
                  onPlay: onPlay,
                ),
                _AudioGoBackButton(onGoBack10Seconds: onGoBack10Seconds),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: _AudioCloseButton(onClose: onClose),
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioTitle extends StatelessWidget {
  const _AudioTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.isDesktopBreakpoint
            ? context.textTheme.labelLarge
            : context.textTheme.labelMedium,
      ),
    );
  }
}

class _AudioDuration extends StatelessWidget {
  const _AudioDuration({
    required this.positionText,
    required this.durationText,
  });

  final String positionText;
  final String durationText;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Text(
        '$positionText / $durationText',
        style: context.isDesktopBreakpoint
            ? context.textTheme.labelMedium
            : context.textTheme.labelSmall,
      ),
    );
  }
}

class _AudioPlayPauseButton extends StatelessWidget {
  const _AudioPlayPauseButton({
    required this.isPlaying,
    required this.onPause,
    required this.onPlay,
  });

  final bool isPlaying;
  final VoidCallback? onPause;
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      tooltip: isPlaying ? context.l10n.pause : context.l10n.play,
      onPressed: isPlaying ? onPause : onPlay,
      icon: AnimatedSwitcher(
        duration: Durations.short4,
        child: Icon(
          key: ValueKey(isPlaying),
          isPlaying ? Icons.pause_outlined : Icons.play_arrow_outlined,
        ),
      ),
    );
  }
}

class _AudioGoBackButton extends StatelessWidget {
  const _AudioGoBackButton({
    required this.onGoBack10Seconds,
  });

  final VoidCallback? onGoBack10Seconds;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      onPressed: onGoBack10Seconds,
      icon: const Icon(Icons.replay_10_outlined),
      tooltip: context.l10n.goBack10Seconds,
    );
  }
}

class _AudioCloseButton extends StatelessWidget {
  const _AudioCloseButton({
    required this.onClose,
  });

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      onPressed: onClose,
      icon: const Icon(Icons.close),
      tooltip: context.l10n.storyPageClosePlayerButton,
    );
  }
}

/// Hook that creates an [AudioPlayer].
AudioPlayer useAudioPlayer({required String url}) {
  return use(_AudioPlayerHook(url: url));
}

class _AudioPlayerHook extends Hook<AudioPlayer> {
  const _AudioPlayerHook({required this.url});

  final String url;

  @override
  _AudioPlayerHookState createState() => _AudioPlayerHookState();
}

class _AudioPlayerHookState extends HookState<AudioPlayer, _AudioPlayerHook> {
  late final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initHook() {
    _audioPlayer.setSourceUrl(hook.url);
    super.initHook();
  }

  @override
  AudioPlayer build(BuildContext context) => _audioPlayer;

  @override
  void dispose() => _audioPlayer.dispose();

  @override
  Object? get debugValue => _audioPlayer;

  @override
  String? get debugLabel =>
      'useAudioPlayer(playerId: ${_audioPlayer.playerId})';
}
