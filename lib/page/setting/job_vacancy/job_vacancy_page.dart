
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/adding_service/widget/reset_and_add_row_widget.dart';
import 'package:salon/page/setting/job_vacancy/review_job_vacancy_page.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../project_specific/simple_text_field.dart';

class JobVacancyPage extends StatefulWidget {
  const JobVacancyPage({super.key});

  @override
  State<JobVacancyPage> createState() => _JobVacancyPageState();
}

class _JobVacancyPageState extends State<JobVacancyPage> {
  final _jobRole = TextEditingController();
  final _basicRequirement = TextEditingController();
  final _role = TextEditingController();
  final _salary = TextEditingController();
  final _benefits = TextEditingController();
  final _location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Job Details",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          _countRowWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SimpleTextFieldWidget(
                      textEditingController: _jobRole,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Job Role"),
                  const SizedBox(height: 16),
                  SimpleTextFieldWidget(
                      textEditingController: _basicRequirement,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Basic Requirements"),
                  const SizedBox(height: 16),
                  _address(
                      textEditingController: _role,
                      hintText: "Start Writing....",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Role Description"),
                  const SizedBox(height: 16),
                  _minimumExperience(),
                  const SizedBox(height: 16),
                  SimpleTextFieldWidget(
                      textEditingController: _salary,
                      hintText: "Job Role",
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      title: "Salary"),
                  const SizedBox(height: 16),
                  SimpleTextFieldWidget(
                      textEditingController: _benefits,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Benefits & Amenties"),
                  const SizedBox(height: 16),
                  SimpleTextFieldWidget(
                      textEditingController: _location,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Locations"),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          ResetAndAddRowWidget(
            buttonAdd: "Next",
            buttonRest: "Reset",
            reset: () {},
            add: () {

              Get.to(()=> const ReviewJobVacancyPage());
            },
          )
        ],
      ),
    );
  }

  /*---------------- Count Row Widget -------------*/
  _countRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "1",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstant.primaryColor,
                    ),
                    shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 100, left: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Details",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Preview",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*--------------- Minimum Experience ---------------*/
  int year = 1;
  _minimumExperience() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Minimum Experience (in No.)",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$year Years",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 14),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (year != 1) {
                              year--;
                            }
                          });
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: const BoxDecoration(
                              color: ColorConstant.experienceColor,
                              shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(
                              Icons.remove,
                              color: ColorConstant.whiteColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            year++;
                          });
                        },
                        child: Container(
                          height: 26,
                          width: 26,
                          decoration: const BoxDecoration(
                              color: ColorConstant.experienceColor,
                              shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(
                              Icons.add,
                              color: ColorConstant.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  /*------------ Saloon Address TextField -----------*/
  _address({
    required TextEditingController textEditingController,
    required String hintText,
    required String title,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
              height: 110,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: TextField(
                controller: textEditingController,
                maxLines: 8,
                keyboardType: textInputType,
                textInputAction: textInputAction,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, top: 15),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayColor, fontSize: 13)),
              )),
        ],
      ),
    );
  }
}
