// ignore_for_file: avoid_redundant_argument_values

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/env/env.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'talker.g.dart';

final talkerInstance = TalkerFlutter.init(
  logger: TalkerLogger(
    formatter: kIsProd
        ? const SimpleLoggerFormatter()
        : const ColoredLoggerFormatter(),
    settings: TalkerLoggerSettings(
      level: kIsProd ? LogLevel.info : LogLevel.verbose,
      maxLineWidth: 120,
      enableColors: !kIsProd,
    ),
  ),
);

class SimpleLoggerFormatter implements LoggerFormatter {
  const SimpleLoggerFormatter();

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    return details.message?.toString() ?? '';
  }
}

@Riverpod(keepAlive: true)
Talker talker(TalkerRef ref) => talkerInstance;

@Riverpod(keepAlive: true)
TalkerRouteObserver talkerRouteObserver(TalkerRouteObserverRef ref) =>
    TalkerRouteObserver(
      ref.watch(talkerProvider),
    );
