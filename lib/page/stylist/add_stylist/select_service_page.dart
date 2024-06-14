import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';

import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'add_service_bottom_seet.dart';

class SelectServicePage extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String experience;
  final String address;
  final String whatsappNo;
  final String panNo;
  final String password;
  final bool isHomeService;
  final String gender;
  final bool isUpdate;
  final String artistId;
  final String birthdate;
  final File image;
  const SelectServicePage(
      {super.key,
      required this.name,
      required this.phone,
      required this.email,
      required this.experience,
      required this.address,
      required this.whatsappNo,
      required this.panNo,
      required this.password,
      required this.isHomeService,
      required this.gender,
      required this.birthdate,
      required this.image,
      required this.isUpdate,
      required this.artistId});

  @override
  State<SelectServicePage> createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    _homeController.gender.clear();
    _homeController.serviceId.clear();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Select Service",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          _countRowWidget(),
          _selectAService(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: false,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  )),
                  context: context,
                  builder: (context) {
                    return AddServicesForStylistPage(
                      artistId: widget.artistId,
                      isEdit: widget.isUpdate,
                      callback: () {
                        setState(() {
                          _homeController.gender.clear();
                          _homeController.serviceId.clear();
                          for (int i = 0;
                              i <
                                  _homeController
                                      .getSalonServiceList.data!.length;
                              i++) {
                            if (_homeController.getSalonServiceList.data![i]
                                    .isSelectService ??
                                false) {
                              _homeController.serviceId.add(_homeController
                                  .getSalonServiceList.data![i].id);
                              _homeController.gender.add(_homeController
                                          .getSalonServiceList
                                          .data![i]
                                          .selectGender ==
                                      1
                                  ? "male"
                                  : _homeController.getSalonServiceList.data![i]
                                              .selectGender ==
                                          2
                                      ? "female"
                                      : "unisex");
                            }
                          }
                        });
                      },
                    );
                  });
            },
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: Get.width,
            color: ColorConstant.lightColor,
            child: Text(
              "Recently Added:",
              textAlign: TextAlign.start,
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.primaryColor, fontSize: 13),
            ),
          ),
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : _homeController.getSalonServiceList.data?.isEmpty ?? false
                      ? const SizedBox()
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: ColorConstant.dividerColor,
                              indent: 21,
                              endIndent: 19,
                            );
                          },
                          itemCount: _homeController
                                  .getSalonServiceList.data?.length ??
                              0,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return _homeController.getSalonServiceList
                                        .data?[index].isSelectService ??
                                    false
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      _homeController.getSalonServiceList
                                              .data?[index].name ??
                                          "",
                                      style: AppTextTheme.medium.copyWith(
                                          color: ColorConstant.blackColor,
                                          fontSize: 16),
                                    ),
                                  )
                                : const SizedBox();
                          }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ButtonWidget(
                buttonTitleText: "ADD",
                onPress: () {
                  if (widget.isUpdate) {
                    if (_homeController.serviceId.isEmpty &&
                        _homeController.gender.isEmpty) {
                      showMessage("Please Select Service");
                    } else {
                      List<String> storeServiceId = [];
                      List<String> genderStore = [];

                      for (int i = 0;
                          i < _homeController.serviceId.length;
                          i++) {
                        storeServiceId.add(_homeController.serviceId[i]);
                      }

                      for (int i = 0; i < _homeController.gender.length; i++) {
                        genderStore.add(_homeController.gender[i]);
                      }
                      _homeController.doUpdateStylistService(
                          artistId: widget.artistId,
                          storeId: storeServiceId,
                          genderDataList: genderStore,
                          callback: () {
                            Get.back();
                            _homeController.doSalonArtistList();
                          });
                    }
                  } else {
                    if (_homeController.serviceId.isEmpty &&
                        _homeController.gender.isEmpty) {
                      showMessage("Please Select Service");
                    } else {
                      List<String> storeServiceId = [];
                      List<String> genderStore = [];

                      for (int i = 0;
                          i < _homeController.serviceId.length;
                          i++) {
                        storeServiceId.add(_homeController.serviceId[i]);
                      }

                      for (int i = 0; i < _homeController.gender.length; i++) {
                        genderStore.add(_homeController.gender[i]);
                      }

                      _homeController.doAddArtiest(
                          name: widget.name,
                          mobile: widget.phone,
                          countryCode: "91",
                          email: widget.email,
                          experience: widget.experience,
                          address: widget.address,
                          whatsapp: widget.whatsappNo,
                          panCard: widget.panNo,
                          homeService: widget.isHomeService.toString(),
                          password: widget.password,
                          gender: widget.gender,
                          dob: widget.birthdate,
                          image: widget.image,
                          storeId: storeServiceId,
                          genderDataList: genderStore,
                          callback: () {
                            Get.back();
                            Get.back();
                            Get.back();
                            _homeController.doSalonArtistList();
                          });
                    }
                  }
                }),
          ),
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
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "2",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.grayTextColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorConstant.grayTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 60, left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "basic info",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Select  Service",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                const SizedBox(width: 5),
                Text(
                  "Review",
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

  /*-------------- Select A Service  -------------*/
  _selectAService({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select A Service",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    "Tap To Enter",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 14),
                  ),
                  const Icon(
                    Icons.add,
                    color: ColorConstant.grayTextColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
