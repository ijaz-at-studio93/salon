import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../model/stylist/artist_portfolio_model.dart';

class StylistAbout extends StatefulWidget {
  final ArtistPortfolioModel artistPortfolioModel;
  const StylistAbout({super.key, required this.artistPortfolioModel});

  @override
  State<StylistAbout> createState() => _StylistAboutState();
}

class _StylistAboutState extends State<StylistAbout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.whiteColor,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _rowWidget(
                title: "Name",
                subTitle: widget.artistPortfolioModel.data?.name ?? ""),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "email",
                subTitle: widget.artistPortfolioModel.data?.email ?? ""),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "Dob",
                subTitle: widget.artistPortfolioModel.data?.dob ?? ""),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "Mobile",
                subTitle:
                    "+91 ${widget.artistPortfolioModel.data?.mobile ?? ""}"),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "Experience",
                subTitle:
                    widget.artistPortfolioModel.data?.experience.toString() ??
                        ""),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "Gender",
                subTitle: widget.artistPortfolioModel.data?.gender ?? ""),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "HomeService",
                subTitle:
                    widget.artistPortfolioModel.data?.homeService.toString() ??
                        ""),
            const Divider(
              height: 30,
              color: ColorConstant.grayTextColor,
              endIndent: 20,
              indent: 20,
            ),
            _rowWidget(
                title: "Review & Rating",
                subTitle:
                    "${widget.artistPortfolioModel.data?.rating ?? ""}  ( review ${widget.artistPortfolioModel.data?.reviewCount.toString() ?? ""} )"),
          ],
        ),
      ),
    );
  }

  /*---------------------  Widget For Data  For Row Widget ---------------*/
  _rowWidget({required String title, required String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.medium
                .copyWith(fontSize: 16, color: ColorConstant.grayTextColor),
          ),
          Text(
            subTitle,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.bold
                .copyWith(fontSize: 16, color: ColorConstant.blackColor),
          ),
        ],
      ),
    );
  }
}
