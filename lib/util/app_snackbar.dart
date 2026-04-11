import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

/// Shows a snackbar using [ScaffoldMessenger] under the root [Navigator].
///
/// Avoids [Get.snackbar] / [Get.showSnackbar], which call
/// `Overlay.of(Get.overlayContext!)`. GetX resolves `overlayContext` by taking
/// a child of the navigator overlay; when a [video_player] surface is present,
/// that can be [_Theater], which has no [Overlay] ancestor and crashes.
void showAppSnackbar(
  String title,
  String message, {
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
  Color? backgroundColor,
  Color textColor = Colors.white,
  Widget? leading,
  VoidCallback? onTap,
}) {
  final ctx = Get.key.currentContext;
  if (ctx == null) return;
  final messenger = ScaffoldMessenger.maybeOf(ctx);
  if (messenger == null) return;

  final size = MediaQuery.sizeOf(ctx);
  final padding = MediaQuery.paddingOf(ctx);

  final EdgeInsets margin;
  if (snackPosition == SnackPosition.TOP) {
    margin = EdgeInsets.only(
      left: 12,
      right: 12,
      bottom: size.height - padding.top - 100,
    );
  } else {
    margin = const EdgeInsets.all(12);
  }

  final content = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      const SizedBox(height: 4),
      Text(message, style: TextStyle(color: textColor)),
    ],
  );

  messenger.showSnackBar(
    SnackBar(
      content: onTap != null || leading != null
          ? InkWell(
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[
                    leading,
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: content),
                ],
              ),
            )
          : content,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: margin,
      backgroundColor: backgroundColor ?? Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
  );
}

/// Error toasts from [Dio] interceptors — same look as the former [GetSnackBar].
void showDioStyleSnackBar(String message, {int duration = 2}) {
  final ctx = Get.key.currentContext;
  if (ctx == null) return;
  final messenger = ScaffoldMessenger.maybeOf(ctx);
  if (messenger == null) return;
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextTheme.medium
            .copyWith(fontSize: 15, color: ColorConstant.whiteColor),
      ),
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(12),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.grey.shade900,
    ),
  );
}
