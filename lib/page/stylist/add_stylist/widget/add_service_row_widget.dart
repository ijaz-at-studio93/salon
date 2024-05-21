import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/salon_service_list_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddServiceRowWidget extends StatefulWidget {
  final SalonService salonService;
  const AddServiceRowWidget({super.key, required this.salonService});

  @override
  State<AddServiceRowWidget> createState() => _AddServiceRowWidgetState();
}

class _AddServiceRowWidgetState extends State<AddServiceRowWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.salonService.name ?? "",
                style: AppTextTheme.medium.copyWith(
                  color: ColorConstant.blackColor,
                  fontSize: 16,
                ),
              ),
              Checkbox(
                  value: widget.salonService.isSelectService ?? false,
                  activeColor: ColorConstant.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      widget.salonService.isSelectService = val ?? false;
                    });
                  })
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.salonService.selectGender = 1;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "male",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.blackColor, fontSize: 13),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 16,
                      width: 16,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.salonService.selectGender == 1
                              ? ColorConstant.primaryColor
                              : ColorConstant.blackColor,
                        ),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.salonService.selectGender == 1
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.salonService.selectGender = 2;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "female",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.blackColor, fontSize: 13),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 16,
                      width: 16,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.salonService.selectGender == 2
                              ? ColorConstant.primaryColor
                              : ColorConstant.blackColor,
                        ),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.salonService.selectGender == 2
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.salonService.selectGender = 3;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "unisex",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.blackColor, fontSize: 13),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 16,
                      width: 16,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.salonService.selectGender == 3
                              ? ColorConstant.primaryColor
                              : ColorConstant.blackColor,
                        ),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.salonService.selectGender == 3
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
