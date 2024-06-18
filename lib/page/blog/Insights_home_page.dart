import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/util/NoItemsWidget.dart';
import '../../constant/api_constant.dart';
import '../../constant/color_constant.dart';
import '../../project_specific/progressbar_view.dart';
import '../../project_specific/text_theme.dart';
import '../stylist_all_module/stylist_home_page/blog/Insights_card_widget.dart';
import 'insights_detail_page.dart';

class InsightsHomePage extends StatefulWidget {
  final  String url;
  const InsightsHomePage({super.key, required this.url});

  @override
  State<InsightsHomePage> createState() => _InsightsHomePageState();
}

class _InsightsHomePageState extends State<InsightsHomePage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetSalonBlogData(url: widget.url,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorConstant.whiteColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorConstant.blackColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Blog",
          style: AppTextTheme.bold
              .copyWith(color: ColorConstant.blackColor, fontSize: 19),
        ),
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : _homeController.getBlogDataGetModel.data?.isEmpty ??
                    false || _homeController.getBlogDataGetModel.data == null
                ? const NoItemsWidget(text: "No Blog Data Found")
                : ListView.separated(
                    separatorBuilder: (context, i) {
                      return const Divider(
                        thickness: 2,
                        color: ColorConstant.divider2Color,
                        indent: 20,
                        endIndent: 20,
                      );
                    },
                    shrinkWrap: true,
                    itemCount:
                        _homeController.getBlogDataGetModel.data?.length ?? 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    itemBuilder: (context, i) {
                      return InsightsCardWidget(
                        blogData: _homeController.getBlogDataGetModel.data![i],
                        onPress: () {
                          Get.to(() => InsightsDetailPage(
                                body: _homeController.getBlogDataGetModel
                                        .data?[i].description ??
                                    "",
                                title: _homeController
                                        .getBlogDataGetModel.data?[i].title ??
                                    "",
                                subTitle: _homeController
                                        .getBlogDataGetModel.data?[i].body ??
                                    "",
                                image:
                                    "${APIConstants.image}${_homeController.getBlogDataGetModel.data?[i].image ?? ""}",
                              ));
                        },
                      );
                    }),
      ),
    );
  }
}
