import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/theme/theme.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
  AppDimensions get dimensions => appDimensions;
}

extension BreakpointsExtension on BuildContext {
  Breakpoint get currentBreakpoint => ResponsiveBreakpoints.of(this).breakpoint;
  bool get isMobileBreakpoint => ResponsiveBreakpoints.of(this).isMobile;
  bool get isTabletBreakpoint => ResponsiveBreakpoints.of(this).isTablet;
  bool get isDesktopBreakpoint => ResponsiveBreakpoints.of(this).isDesktop;
}
