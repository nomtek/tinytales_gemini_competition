import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

import '../test_app.dart';
import '../test_extension.dart';

void main() {
  group('AppButtonBar: ', () {
    testWidgets(
      'only primary button set',
      (tester) async {
        await tester.pumpAppButtonBar(
          primaryButton: const Text('Primary'),
        );

        expect(find.text('Primary'), findsOneWidget);
      },
    );

    testWidgets(
      'only secondary button set',
      (tester) async {
        await tester.pumpAppButtonBar(
          secondaryButton: const Text('Secondary'),
        );

        expect(find.text('Secondary'), findsOneWidget);
      },
    );

    testWidgets(
      'primary and secondary set',
      (tester) async {
        await tester.pumpAppButtonBar(
          primaryButton: const Text('Primary'),
          secondaryButton: const Text('Secondary'),
        );

        expect(find.text('Primary'), findsOneWidget);
        expect(find.text('Secondary'), findsOneWidget);
      },
    );

    final deviceSizeVariant = ValueVariant<_DeviceSize>({
      (name: 'desktop', size: const Size(1920, 1080), expectedContainer: Row),
      (name: 'tablet', size: const Size(768, 680), expectedContainer: Column),
      (name: 'mobile', size: const Size(400, 680), expectedContainer: Column),
    });

    testWidgets(
      'buttons are displayed in a specific layout based on screen size',
      variant: deviceSizeVariant,
      (tester) async {
        final currentVariant = deviceSizeVariant.currentValue!;
        await tester.setDeviceSize(currentVariant.size);
        await tester.pumpAppButtonBar(
          primaryButton: const Text('Primary'),
          secondaryButton: const Text('Secondary'),
        );
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(currentVariant.expectedContainer),
            matching: find.text('Primary'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(currentVariant.expectedContainer),
            matching: find.text('Secondary'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}

typedef _DeviceSize = ({String name, Size size, Type expectedContainer});

extension on WidgetTester {
  Future<void> pumpAppButtonBar({
    Widget? primaryButton,
    Widget? secondaryButton,
  }) =>
      pumpWidget(
        TestAppWidget(
          child: AppButtonBar(
            primaryButton: primaryButton,
            secondaryButton: secondaryButton,
          ),
        ),
      );
}
