import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'Insights_card_widget.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stylistController.doGetBlog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Post Blog",
        isBackIcon: true,
      ),
      body: Obx(
        () => _stylistController.showProgress
            ? const ProgressBarView()
            : ListView.separated(
                separatorBuilder: (context, i) {
                  return const Divider(
                    thickness: 2,
                    color: ColorConstant.dividerColor,
                    indent: 20,
                    endIndent: 20,
                  );
                },
                shrinkWrap: true,
                itemCount:
                    _stylistController.getBlogDataGetModelModel.data?.length ??
                        0,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                itemBuilder: (context, i) {
                  return InsightsCardWidget(
                    blogData:
                        _stylistController.getBlogDataGetModelModel.data![i],
                    onPress: () {},
                  );
                }),
      ),
    );
  }
}
