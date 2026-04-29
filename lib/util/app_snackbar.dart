import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

/// Shows a snackbar using [ScaffoldMessenger] under the root [Navigator].
///
/// For [SnackPosition.TOP], uses an [OverlayEntry] instead of the
/// ScaffoldMessenger so the banner is not height-constrained by a large
/// bottom-margin hack (which clips multi-line notification text).
///
/// Still avoids [Get.snackbar] / [Get.showSnackbar] for bottom toasts because
/// GetX resolves `overlayContext` via a navigator child that can be [_Theater]
/// when a video_player surface is present, causing a crash.
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

  if (snackPosition == SnackPosition.TOP) {
    _showTopOverlay(
      ctx,
      title,
      message,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      leading: leading,
      onTap: onTap,
    );
    return;
  }

  final messenger = ScaffoldMessenger.maybeOf(ctx);
  if (messenger == null) return;

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
      margin: const EdgeInsets.all(12),
      backgroundColor: backgroundColor ?? Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
  );
}

/// Shows a dismissible notification banner anchored to the top of the screen
/// using an [OverlayEntry]. This avoids the height-clipping that occurs when
/// using ScaffoldMessenger with a large bottom margin.
void _showTopOverlay(
  BuildContext ctx,
  String title,
  String message, {
  required Duration duration,
  Color? backgroundColor,
  Color textColor = Colors.white,
  Widget? leading,
  VoidCallback? onTap,
}) {
  // Get.key.currentContext is the Navigator's own context — its Overlay is a
  // descendant, not an ancestor, so Overlay.of(ctx) won't find it. Pull the
  // OverlayState straight from the NavigatorState instead.
  final overlay = Get.key.currentState?.overlay ??
      Overlay.maybeOf(ctx, rootOverlay: true);
  if (overlay == null) return;

  late OverlayEntry entry;

  void dismiss() {
    if (entry.mounted) entry.remove();
  }

  entry = OverlayEntry(
    builder: (context) => _TopNotificationBanner(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.black87,
      textColor: textColor,
      leading: leading,
      onTap: onTap,
      onDismiss: dismiss,
    ),
  );

  overlay.insert(entry);
}

class _TopNotificationBanner extends StatefulWidget {
  const _TopNotificationBanner({
    required this.title,
    required this.message,
    required this.duration,
    required this.backgroundColor,
    required this.textColor,
    required this.onDismiss,
    this.leading,
    this.onTap,
  });

  final String title;
  final String message;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;
  final Widget? leading;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  @override
  State<_TopNotificationBanner> createState() => _TopNotificationBannerState();
}

class _TopNotificationBannerState extends State<_TopNotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slide,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, topPadding > 0 ? 4 : 12, 12, 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap != null
                    ? () {
                        _dismiss();
                        widget.onTap!();
                      }
                    : null,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.leading != null) ...[
                        widget.leading!,
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: widget.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.message,
                              style: TextStyle(color: widget.textColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
