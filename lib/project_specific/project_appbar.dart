import 'package:flutter/material.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../constant/assetsconstant.dart';
import '../constant/color_constant.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String nameOfScreen;
  final bool isBackIcon;
  final Widget? rightWidget;
  final VoidCallback? callback;
  final List<Widget>? actions;
  final bool? fontSize;
  final Widget? title;

  const AppBarWidget(
      {super.key,
      required this.nameOfScreen,
      this.callback,
      this.isBackIcon = true,
      this.actions,
      this.fontSize = true,
      this.rightWidget,
      this.title});

  @override
  Widget build(BuildContext context) {
    // Build final actions list:
    final List<Widget> finalActions = [];
    if (actions != null && actions!.isNotEmpty) {
      finalActions.addAll(actions!);
    }
    if (rightWidget != null) {
      // ensure some padding so it sits nicely in the appbar
      finalActions.add(Padding(
        padding: const EdgeInsets.only(right: 12),
        child: rightWidget!,
      ));
    }

    return AppBar(
      elevation: 1.0,
      backgroundColor: ColorConstant.whiteColor,
      centerTitle: true,
      title: title ??
          Text(nameOfScreen,
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 19)),
      // show leading only when required
      leadingWidth: isBackIcon ? 80 : 0,
      leading: isBackIcon
          ? InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                Navigator.pop(context);
                callback?.call();
              },
              child: Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(7),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    AssetsConstant.arrowLeftIcon,
                    color: ColorConstant.blackColor,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      actions: finalActions.isNotEmpty ? finalActions : [const SizedBox()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
