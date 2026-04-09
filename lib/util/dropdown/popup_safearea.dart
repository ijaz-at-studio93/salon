import 'package:flutter/material.dart';

class PopupSafeArea {
  final bool left;

  final bool top;

  final bool right;

  final bool bottom;

  final EdgeInsets minimum;

  final bool maintainBottomViewPadding;

  const PopupSafeArea({
    this.left = false,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });
}
