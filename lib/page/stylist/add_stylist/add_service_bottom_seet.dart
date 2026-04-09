import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'widget/add_service_row_widget.dart';

class AddServicesForStylistPage extends StatefulWidget {
  final VoidCallback callback;
  final bool isEdit;
  final String artistId;
  const AddServicesForStylistPage(
      {super.key,
      required this.callback,
      required this.isEdit,
      required this.artistId});

  @override
  State<AddServicesForStylistPage> createState() =>
      _AddServicesForStylistPageState();
}

class _AddServicesForStylistPageState extends State<AddServicesForStylistPage> {
  final _serviceTextEditingController = TextEditingController();

  final _homeController = Get.find<HomeController>();
  String? serviceId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetSalonServiceList();
      if (widget.isEdit) {
        _homeController.doGetArtiestDetails(
            artistId: widget.artistId, callback: () {
          selectService();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
                Text(
                  "Add Services",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                TextButton(
                    onPressed: () {
                      widget.callback();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Done",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _searchAndService(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
              "Suggested Service:",
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
            ),
          ),
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: ColorConstant.dividerColor,
                          endIndent: 20,
                          height: 0,
                          indent: 20,
                        );
                      },
                      shrinkWrap: true,
                      itemCount:
                          _homeController.getSalonServiceList.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AddServiceRowWidget(
                            salonService: _homeController
                                .getSalonServiceList.data![index],
                          ),
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }

  /*------------------ Search and Service ---------------*/
  _searchAndService() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: ColorConstant.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset(
            AssetsConstant.search,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: Get.width * 0.8,
            child: TextField(
              controller: _serviceTextEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "",
                  hintStyle: AppTextTheme.regular.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor)),
            ),
          ),
        ],
      ),
    );
  }

  selectService() {
    setState(() {
      for (int i = 0;
          i < _homeController.getArtiestDetailsModel.data!.services!.length;
          i++) {
        serviceId =
            _homeController.getArtiestDetailsModel.data?.services?[i].id ?? "";
      }

      for (int i = 0;
          i < _homeController.getSalonServiceList.data!.length;
          i++) {
        if (_homeController.getSalonServiceList.data?[i].id == serviceId) {

          _homeController.getSalonServiceList.data?[i].isSelectService = true;
        }
      }
    });
  }
}
