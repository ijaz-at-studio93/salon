import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/model/service_model/category_list_model.dart';

import 'package:salon/project_specific/text_theme.dart';

import '../../../../constant/color_constant.dart';

class AddCategoryListTileWidget extends StatefulWidget {
  final VoidCallback callback;
  final CategoryDataList categoryDataList;
  const AddCategoryListTileWidget(
      {super.key, required this.callback, required this.categoryDataList});

  @override
  State<AddCategoryListTileWidget> createState() =>
      _AddCategoryListTileWidgetState();
}

class _AddCategoryListTileWidgetState extends State<AddCategoryListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.callback,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.categoryDataList.name ?? "",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            if (widget.categoryDataList.isSelect ?? false)
              const Icon(
                CupertinoIcons.check_mark,
                color: ColorConstant.primaryColor,
                size: 18,
              )
            else
              const SizedBox(),
          ],
        ),
      ),
    );
  }
}
