import 'package:flutter/cupertino.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class SetAvailabilityListTileWidget extends StatefulWidget {

  const SetAvailabilityListTileWidget({super.key, });

  @override
  State<SetAvailabilityListTileWidget> createState() =>
      _SetAvailabilityListTileWidgetState();
}

class _SetAvailabilityListTileWidgetState
    extends State<SetAvailabilityListTileWidget> {
    bool  isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical:10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Monday",
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 15, top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorConstant.grayTextColor,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "HH/MM/SS",
                      style: AppTextTheme.regular.copyWith(
                          fontSize: 14, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      AssetsConstant.slotIcon,
                      width: 15,
                      height: 15,
                    )
                  ],
                ),
              ),
              Text(
                "TO",
                style: AppTextTheme.regular
                    .copyWith(fontSize: 14, color: ColorConstant.grayTextColor),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 15, top: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorConstant.grayTextColor,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "HH/MM/SS",
                      style: AppTextTheme.regular.copyWith(
                          fontSize: 14, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      AssetsConstant.slotIcon,
                      width: 15,
                      height: 15,
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: isSwitch,
                activeColor: ColorConstant.primaryColor,
                onChanged: (bool? value) {
                  setState(() {
                    isSwitch = value ?? false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
