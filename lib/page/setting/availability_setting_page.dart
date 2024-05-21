import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';

class AvailabilitySettingPage extends StatefulWidget {
  const AvailabilitySettingPage({super.key});

  @override
  State<AvailabilitySettingPage> createState() =>
      _AvailabilitySettingPageState();
}

class _AvailabilitySettingPageState extends State<AvailabilitySettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar:
          const AppBarWidget(nameOfScreen: "Availability"),
      body: Column(
        children: [],
      ),
    );
  }
}
