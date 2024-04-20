import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddServiceRowWidget extends StatefulWidget {
  const AddServiceRowWidget({super.key});

  @override
  State<AddServiceRowWidget> createState() => _AddServiceRowWidgetState();
}

class _AddServiceRowWidgetState extends State<AddServiceRowWidget> {
  bool isAdd = false;
  int _selectedGender = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Underarm shaving",
                style: AppTextTheme.medium.copyWith(
                  color: ColorConstant.blackColor,
                  fontSize: 16,
                ),
              ),
              Checkbox(
                  value: isAdd,
                  activeColor: ColorConstant.primaryColor,
                  onChanged: (val) {
                    setState(() {
                      isAdd = val ?? false;
                    });
                  })
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGender = 1;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Men",
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
                          color: _selectedGender == 1
                              ? ColorConstant.primaryColor
                              : ColorConstant.blackColor,
                        ),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedGender == 1
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
                    _selectedGender = 2;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Women",
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
                          color: _selectedGender == 2
                              ? ColorConstant.primaryColor
                              : ColorConstant.blackColor,
                        ),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedGender == 2
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
                    _selectedGender = 3;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Both",
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
                          color: _selectedGender == 3
                              ? ColorConstant.primaryColor
                              : ColorConstant.blackColor,
                        ),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedGender == 3
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
