import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void semanticsAnnouncement({
  required BuildContext context,
  required String text,
}) {
  SemanticsService.announce(text, Directionality.of(context));
}
