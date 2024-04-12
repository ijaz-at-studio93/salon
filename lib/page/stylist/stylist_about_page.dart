import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/page/stylist/widget/review_and_ratings_widget.dart';
import 'package:salon/page/stylist/widget/service_offered_list_tile_widget.dart';
import 'package:salon/page/stylist/widget/stylist_portfolio_gird_view.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/assetsconstant.dart';
import '../../constant/color_constant.dart';
import '../../project_specific/status_bar_color_appbar.dart';

class StylistAboutPage extends StatefulWidget {
  const StylistAboutPage({super.key});

  @override
  State<StylistAboutPage> createState() => _StylistAboutPageState();
}

class _StylistAboutPageState extends State<StylistAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: statusBarTheme(context),
      backgroundColor: ColorConstant.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageHeaderWidget(),
            _nameContainColum(),
            _tabBarView(),
            isSelectedTab == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "5 Service",
                          style: AppTextTheme.regular.copyWith(
                              color: ColorConstant.grayTextColor, fontSize: 15),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            color: ColorConstant.primaryColor,
                            radius: const Radius.circular(66),
                            padding: const EdgeInsets.all(4),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                height: 30,
                                width: 100,
                                color: ColorConstant.lightColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.add,
                                      color: ColorConstant.primaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Add New",
                                      style: AppTextTheme.regular.copyWith(
                                          color: ColorConstant.primaryColor,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            isSelectedTab == 1
                ? ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider(
                        endIndent: 20,
                        indent: 20,
                        color: ColorConstant.grayTextColor,
                      );
                    },
                    itemCount: 5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: ServiceOfferedListTileWidget(
                            onPress: () {},
                          ));
                    })
                : isSelectedTab == 2
                    ? const StylistPortfolioGridview()
                    : const ReviewAndRating(),
          ],
        ),
      ),
    );
  }

  /*-------------- Image header Widget ------------*/
  _imageHeaderWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1485686531765-ba63b07845a7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bGFrbWUlMjBzYWxvb258ZW58MHx8MHx8fDA%3D',
          width: Get.width,
          height: Get.height * 0.28,
          fit: BoxFit.fitWidth,
        ),
        Positioned(
            child: Container(
          width: Get.width,
          height: Get.height * 0.28,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.02, 1.00),
              end: Alignment(-0.02, -1),
              colors: [Colors.black, Color(0x003D3636)],
            ),
          ),
        )),
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonWidget(
                imageUrl: AssetsConstant.backArrow,
                onPress: () {
                  Get.back();
                },
                h: 15,
                w: 15,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: ColorConstant.bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://www.iwmbuzz.com/wp-content/uploads/2020/08/neha-kakkar-hairstyle-take-hair-styling-tips-for-curly-hair-for-girls-4.jpg",
                  height: 100,
                  width: 100,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*------------ Back Button --------------*/
  buttonWidget(
      {required String imageUrl,
      required VoidCallback onPress,
      required double h,
      required double w}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstant.blackColor.withOpacity(0.50),
          ),
          child: Center(
            child: Image.asset(
              imageUrl,
              width: w,
              height: h,
              fit: BoxFit.contain,
            ),
          )),
    );
  }

  /*------------ Naming Contain Colum --------*/
  _nameContainColum() {
    return Column(
      children: [
        SizedBox(height: Get.height * 0.07),
        Text(
          "Neha Kakkar",
          style: AppTextTheme.bold
              .copyWith(color: ColorConstant.blackColor, fontSize: 19),
        ),
        const SizedBox(height: 5),
        Text(
          "Barber at RedBox Hair Saloon",
          style: AppTextTheme.medium
              .copyWith(fontSize: 13, color: ColorConstant.grayTextColor),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: 3.5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 25.0,
              ignoreGestures: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: ColorConstant.primaryColor,
                size: 25,
              ),
              onRatingUpdate: (rating) {},
            ),
            Text(
              "(125 Reviews)",
              style: AppTextTheme.medium
                  .copyWith(fontSize: 13, color: ColorConstant.grayTextColor),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ReadMoreText(
            'n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a....',
            trimMode: TrimMode.Line,
            style: AppTextTheme.medium.copyWith(
                height: 1.5, color: ColorConstant.grayTextColor, fontSize: 14),
            trimLines: 2,
            colorClickableText: ColorConstant.primaryColor,
            trimCollapsedText: 'more',
            trimExpandedText: 'Show less',
            moreStyle: AppTextTheme.medium
                .copyWith(fontSize: 15, color: ColorConstant.primaryColor),
          ),
        ),
      ],
    );
  }

  /*------------- Tab Bar View ------------*/
  int isSelectedTab = 1;
  _tabBarView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectedTab = 1;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Service Offered",
                      style: isSelectedTab == 1
                          ? AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor)
                          : AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                          color: isSelectedTab == 1
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectedTab = 2;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Portfolio",
                      style: isSelectedTab == 2
                          ? AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor)
                          : AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                          color: isSelectedTab == 2
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectedTab = 3;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Review & ratings",
                      style: isSelectedTab == 3
                          ? AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor)
                          : AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                          color: isSelectedTab == 3
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: Get.width,
          color: const Color(0xffADADAD),
        ),
      ],
    );
  }
}
