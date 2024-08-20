import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

class GoldenTestApp extends HookConsumerWidget {
  const GoldenTestApp({
    required this.child,
    this.languageCode = const Locale('en'),
    this.overrides = const [],
    this.themeMode = ThemeMode.light,
    super.key,
  });

  final List<Override> overrides;
  final Widget child;
  final Locale languageCode;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseTheme = Theme.of(context);
    final appTheme = AppTheme(textTheme: baseTheme.textTheme);
    final app = MaterialApp(
      title: 'Tinytales',
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      themeMode: themeMode,
      locale: languageCode,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) {
          return ResponsiveBreakpoints(
            breakpoints: appBreakpoints,
            child: ColoredBox(
              color: context.colors.surfaceContainerHighest,
              child: Material(
                child: LoadGoogleFonts(child: child),
              ),
            ),
          );
        },
      ),
    );

    if (overrides.isEmpty) {
      return app;
    } else {
      return ProviderScope(
        overrides: [...overrides],
        child: app,
      );
    }
  }
}

// ensure that the Google Fonts are loaded before rendering the app
class LoadGoogleFonts extends StatefulWidget {
  const LoadGoogleFonts({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<LoadGoogleFonts> createState() => _LoadGoogleFontsState();
}

class _LoadGoogleFontsState extends State<LoadGoogleFonts> {
  late Future<void> _googleFontsFuture;

  @override
  void initState() {
    super.initState();
    _googleFontsFuture = GoogleFonts.pendingFonts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _googleFontsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Text('Loading Google Fonts...');
        } else {
          return widget.child;
        }
      },
    );
  }
}
