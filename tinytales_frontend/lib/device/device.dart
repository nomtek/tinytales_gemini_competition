import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device.g.dart';

@riverpod
Locale deviceLocale(DeviceLocaleRef ref) => PlatformDispatcher.instance.locale;

/// Hook that updates device locale when it changes.
/// Read [deviceLocaleProvider] to get the current device locale.
void useOnDeviceLocaleChanged(void Function() onLocaleChanged) => useEffect(
      () {
        PlatformDispatcher.instance.onLocaleChanged = onLocaleChanged;
        return () => PlatformDispatcher.instance.onLocaleChanged = null;
      },
      [],
    );
