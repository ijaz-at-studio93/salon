import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/service_model/product_list_data_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddProductCheckBoxWidget extends StatefulWidget {
  final Product product;

  final HomeController homeController;
  const AddProductCheckBoxWidget(
      {super.key,
      required this.product,

      required this.homeController});

  @override
  State<AddProductCheckBoxWidget> createState() =>
      _AddProductCheckBoxWidgetState();
}

class _AddProductCheckBoxWidgetState extends State<AddProductCheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.product.name ?? "",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 16),
          ),
          Checkbox(
              value: widget.product.isSelectedProduct ?? false,
              activeColor: ColorConstant.primaryColor,
              onChanged: (val) {
                setState(() {
                  widget.product.isSelectedProduct = val ?? false;
                  widget.homeController.productId.clear();
                });
              })
        ],
      ),
    );
  }
}
