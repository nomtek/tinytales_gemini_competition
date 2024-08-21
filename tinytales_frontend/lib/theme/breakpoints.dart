import 'package:responsive_framework/responsive_framework.dart';

const mobileMinWidth = 0.0;
const mobileMaxWidth = 600.0;
const tabletMinWidth = 601.0;
const tabletMaxWidth = 840.0;
const desktopMinWidth = 841.0;
const desktopMaxWidth = double.infinity;

const appMaxContentWidth = tabletMaxWidth;

const mobileBreakpoint =
    Breakpoint(start: mobileMinWidth, end: mobileMaxWidth, name: MOBILE);

const tabletBreakpoint =
    Breakpoint(start: tabletMinWidth, end: tabletMaxWidth, name: TABLET);

const desktopBreakpoint =
    Breakpoint(start: desktopMinWidth, end: desktopMaxWidth, name: DESKTOP);

const appBreakpoints = [
  mobileBreakpoint,
  tabletBreakpoint,
  desktopBreakpoint,
];
