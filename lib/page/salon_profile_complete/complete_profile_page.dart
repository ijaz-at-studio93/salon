import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'widget/document_submit_widget.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Complete Profile",
        isBackIcon: false,
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : RefreshIndicator(
                onRefresh: getTradLogData,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      _homeController.getSalonDocumentGetModel.data?.length ??
                          0,
                  itemBuilder: (context, index) {
                    return DocumentSubmitWidget(
                        documentListModel: _homeController
                            .getSalonDocumentGetModel.data![index]);
                  },
                ),
              ),
      ),
    );
  }

  /*------------------- Refresh  Function  -------*/
  Future getTradLogData() async {
    _homeController.doCheckEligibility();
    _homeController.doGetSalonDocument();
  }
}
