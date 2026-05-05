import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Consistent spacing for primary actions pinned to the bottom of the screen.
///
/// **Recommended patterns**
/// - Wrap the bottom button row in [ScreenBottomActionArea] so every screen uses
///   the same gap above the home indicator / gesture bar.
/// - Alternatively, use [Scaffold.bottomNavigationBar] for a single full-width
///   action — Material places it correctly above system insets.
/// - For a [SingleChildScrollView] whose last content sits above a fixed bottom
///   button, add bottom padding with [scrollEndPaddingForStackedBottomAction].
abstract final class ScreenBottomInsets {
  ScreenBottomInsets._();

  /// Extra space below the button, beyond the OS safe area (Material-style 16).
  static const double actionGap = 16;

  /// When the device reports no bottom inset, keep at least this much margin
  /// from the physical screen edge.
  static const double minBottomPadding = 16;

  /// Default total height of a primary button strip (e.g. vertical padding +
  /// label/icon). Tune if your control is taller.
  static const double defaultActionContentHeight = 54;

  /// Gap between scroll content and the top edge of a stacked bottom button.
  static const double scrollGapAboveBottomAction = 16;

  /// Total bottom inset for a bottom-pinned control: safe area + [actionGap],
  /// floored by [minBottomPadding] when the OS inset is zero.
  static double actionPadding(
    BuildContext context, {
    double extra = actionGap,
  }) {
    final safe = MediaQuery.paddingOf(context).bottom;
    return math.max(minBottomPadding, safe + extra);
  }

  /// Space to leave at the end of a scroll view when a fixed bottom button is
  /// in a [Column] below the scroll. Does not include OS bottom inset — that
  /// belongs only under the button via [actionPadding] / [ScreenBottomActionArea].
  static double scrollEndPaddingForStackedBottomAction({
    double actionContentHeight = defaultActionContentHeight,
    double gapAboveButton = scrollGapAboveBottomAction,
  }) {
    return gapAboveButton + actionContentHeight;
  }
}

/// Padding for a full-width bottom action so it does not touch the screen edge
/// and stays consistent across phones with or without a home indicator.
class ScreenBottomActionArea extends StatelessWidget {
  const ScreenBottomActionArea({
    super.key,
    required this.child,
    this.horizontalPadding = 20,
    this.extraBottom = ScreenBottomInsets.actionGap,
  });

  final Widget child;
  final double horizontalPadding;
  final double extraBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        ScreenBottomInsets.actionPadding(context, extra: extraBottom),
      ),
      child: child,
    );
  }
}
