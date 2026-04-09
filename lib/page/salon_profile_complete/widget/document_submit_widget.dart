import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/salon_document_model/salon_document_get_model.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../../project_specific/button_widget.dart';

class DocumentSubmitWidget extends StatefulWidget {
  final DocumentListModel documentListModel;
  const DocumentSubmitWidget({super.key, required this.documentListModel});

  @override
  State<DocumentSubmitWidget> createState() => _DocumentSubmitWidgetState();
}

class _DocumentSubmitWidgetState extends State<DocumentSubmitWidget> {
  File imagePath = File("");
  final _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConstant.whiteColor,
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.documentListModel.title ?? "",
                style: AppTextTheme.bold
                    .copyWith(fontSize: 16, color: ColorConstant.blackColor),
              ),
              const SizedBox(width: 10),
              widget.documentListModel.isRequired ?? false
                  ? Text(
                      "*",
                      style: AppTextTheme.bold.copyWith(
                          fontSize: 20, color: ColorConstant.redColor),
                    )
                  : const SizedBox(),
              widget.documentListModel.submittedDocuments?.isEmpty ??  false ? const SizedBox(): widget.documentListModel.submittedDocuments?[0].status ==
                      "verified"
                  ? Image.asset(
                      AssetsConstant.markIcon,
                      height: 20,
                      width: 20,
                    )
                  : const SizedBox(),
            ],
          ),
          const SizedBox(height: 10),
          widget.documentListModel.submittedDocuments?.isEmpty ?? false
              ? GestureDetector(
                  onTap: () {
                    FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                      setState(() {
                        imagePath = file;
                      });
                    });
                  },
                  child: Container(
                    height: 165,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorConstant.borderColor,
                      ),
                    ),
                    child: imagePath.path.isEmpty
                        ? Center(
                            child: Image.asset(
                              AssetsConstant.uploadIcon,
                              height: 24,
                              width: 24,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              imagePath,
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                  ),
                )
              : Container(
                  height: 165,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorConstant.borderColor),
                  ),
                  child: CachedNetworkImage(
                    height: 165,
                    width: Get.width,
                    fit: BoxFit.fitHeight,
                    imageUrl:
                        "${APIConstants.image}${widget.documentListModel.submittedDocuments?[0].documentUrl ?? ""}",
                    placeholder: (context, url) => Image(
                      image: const AssetImage(AssetsConstant.placeHolder),
                      height: 165,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image(
                      image: const AssetImage(AssetsConstant.placeHolder),
                      height: 165,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          const SizedBox(height: 15),
          _homeController.showProgressCategory
              ? const CircularProgressIndicator()
              : widget.documentListModel.submittedDocuments?.isNotEmpty ?? false
                  ? const SizedBox()
                  : ButtonWidget(
                      buttonTitleText: "Submit Document",
                      onPress: () {
                        if (imagePath.path.isEmpty) {
                          showMessage("Please Choose Image");
                        } else {
                          _homeController.doUploadDocument(
                              documentId: widget.documentListModel.id ?? "",
                              image: imagePath,
                              callback: () {
                                _homeController.doGetSalonDocument();
                              });
                        }
                      }),
        ],
      ),
    );
  }
}
