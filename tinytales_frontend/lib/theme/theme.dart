// generate ThemeDate from seed color

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:responsive_framework/responsive_framework.dart';

export 'breakpoints.dart';
export 'dimensions.dart';
export 'theme_extensions.dart';

class AppTheme {
  factory AppTheme({TextTheme? textTheme}) {
    return AppTheme._(
      GoogleFonts.interTextTheme(textTheme).copyWith(
        displayLarge: GoogleFonts.sniglet(
          textStyle: textTheme?.displayLarge,
        ).copyWith(
          fontFamilyFallback: ['Arial'],
        ),
        displayMedium: GoogleFonts.sniglet(
          textStyle: textTheme?.displayMedium,
        ).copyWith(
          fontFamilyFallback: ['Arial'],
        ),
        displaySmall: GoogleFonts.sniglet(
          textStyle: textTheme?.displaySmall,
        ).copyWith(
          fontFamilyFallback: ['Arial'],
        ),
        headlineLarge: GoogleFonts.sniglet(
          textStyle: textTheme?.headlineLarge,
        ).copyWith(
          fontFamilyFallback: ['Arial'],
        ),
        headlineMedium: GoogleFonts.sniglet(
          textStyle: textTheme?.headlineMedium,
        ).copyWith(
          fontFamilyFallback: ['Arial'],
        ),
        headlineSmall: GoogleFonts.sniglet(
          textStyle: textTheme?.headlineSmall,
        ).copyWith(
          fontFamilyFallback: ['Arial'],
        ),
      ),
    );
  }
  const AppTheme._(this.textTheme);

  final TextTheme textTheme;

  ThemeData light() => _light(textTheme);
  ThemeData dark() => _dark(textTheme);
}

const _seed = Color(0xFF33367B);

ThemeData _light(TextTheme textTheme) {
  final colorScheme = ColorScheme.fromSeed(seedColor: _seed);
  final customColors = CustomColors(
    warning: const Color(0xffC96C00),
  );
  return _theme(textTheme, colorScheme, customColors);
}

ThemeData _dark(TextTheme textTheme) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  );
  final customColors = CustomColors(
    warning: const Color(0xffFFA000),
  );
  return _theme(
    textTheme,
    colorScheme,
    customColors,
  );
}

class CustomColors extends ThemeExtension<CustomColors> {
  CustomColors({
    required this.warning,
  });

  final Color warning;

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? warning,
  }) {
    return CustomColors(
      warning: warning ?? this.warning,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    covariant ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}

ThemeData _theme(
  TextTheme textTheme,
  ColorScheme colorScheme,
  CustomColors customColors,
) =>
    ThemeData(
      useMaterial3: true,
      // Override for all platforms to be the same.
      // This adds padding to the tap target to make it easier to tap.
      // This value is used by default on Mobile.
      // Without it on Desktop all buttons have no padding
      // and it's not looking good.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      scaffoldBackgroundColor: colorScheme.surfaceContainerHigh,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainerHigh,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        disabledColor: colorScheme.onSurfaceVariant.withOpacity(0.12),
      ),
      canvasColor: colorScheme.surface,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      dividerTheme: const DividerThemeData(space: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primary,
        contentTextStyle: textTheme.bodyLarge!.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        visualDensity: VisualDensity.standard,
        dense: false,
      ),
      extensions: [customColors],
    );
