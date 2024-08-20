import 'package:flutter/widgets.dart';

enum ScrollOrFitBottomBehavior {
  /// Bottom content is not pushed to the bottom and
  /// always is below the scrollable content.
  alwaysScroll,

  /// Bottom content is pushed to the bottom and
  /// scrolls with the content when it overflows.
  /// Default behavior.
  pushToBottom,
}

// Fills the viewport if the content fits, otherwise scrolls.
// The bottom content is at the bottom of the viewport if the content fits.
// If the content is larger than the viewport, the bottom content
// will scroll with the content.
//
// If used within a Scaffold, resizeToAvoidBottomInset should be left null.
class ScrollOrFitBottom extends StatelessWidget {
  const ScrollOrFitBottom({
    required this.scrollableContent,
    required this.bottomContent,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.behavior = ScrollOrFitBottomBehavior.pushToBottom,
    super.key,
  });
  final Widget scrollableContent;
  final Widget bottomContent;
  final MainAxisAlignment mainAxisAlignment;
  final ScrollOrFitBottomBehavior behavior;

  @override
  Widget build(BuildContext context) {
    switch (behavior) {
      case ScrollOrFitBottomBehavior.alwaysScroll:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            children: <Widget>[
              scrollableContent,
              bottomContent,
            ],
          ),
        );
      case ScrollOrFitBottomBehavior.pushToBottom:
        return CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: scrollableContent),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  bottomContent,
                ],
              ),
            ),
          ],
        );
    }
  }
}
