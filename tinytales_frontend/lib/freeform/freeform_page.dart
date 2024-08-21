import 'package:flutter/material.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/freeform/form/form.dart';

import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

class FreeformPage extends StatelessWidget {
  const FreeformPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added as a solution to minimize the effect of bug
      // https://github.com/flutter/flutter/issues/124205
      // on mobile web.
      resizeToAvoidBottomInset: !isMobileWeb,
      appBar: AppBar(
        title: Text(context.l10n.freeformPageTitle),
      ),
      body: const SafeArea(
        child: AppMaxContentWidth(
          child: FreeformForm(),
        ),
      ),
    );
  }
}
