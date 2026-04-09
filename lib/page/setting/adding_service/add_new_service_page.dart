import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/adding_service/create_new_service_page.dart';
import 'package:salon/page/setting/adding_service/service_list_tile_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddNewServicePage extends StatefulWidget {
  const AddNewServicePage({super.key});

  @override
  State<AddNewServicePage> createState() => _AddNewServicePageState();
}

class _AddNewServicePageState extends State<AddNewServicePage> {
  String _searchQuery = '';
  final _serviceTextEditingController = TextEditingController();
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetSalonServiceList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Service",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _searchAndService(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suggested Service:",
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 15),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        )),
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: _homeController
                                        .getSalonServiceList.data?.isNotEmpty ??
                                    false
                                ? CreateNewServicePage(
                                    serviceId: "",
                                    isUpdate: false,
                                    salonService: _homeController
                                        .getSalonServiceList.data!.first,
                                  )
                                : const CreateNewServicePage(
                                    serviceId: "",
                                    isUpdate: false,
                                    salonService: null,
                                  ),
                          );
                        });
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: ColorConstant.primaryColor,
                    radius: const Radius.circular(66),
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          ),
          const SizedBox(height: 20),
          Obx(
                () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    // compute filtered list
                    Builder(builder: (context) {
                      final allServices = _homeController.getSalonServiceList.data ?? [];
                      final query = _searchQuery.trim().toLowerCase();
                      final services = query.isEmpty
                          ? allServices
                          : allServices.where((s) {
                        final name = (s.name ?? '').toString().toLowerCase();
                        final desc = (s.description ?? '').toString().toLowerCase();
                        return name.contains(query) || desc.contains(query);
                      }).toList();

                      return ListView.separated(
                          separatorBuilder: (context, index) {
                            return const Divider(
                              endIndent: 20,
                              indent: 20,
                              color: ColorConstant.grayTextColor,
                            );
                          },
                          itemCount: services.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final svc = services[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: ServiceListTileWidget(
                                editOnTap: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32),
                                            topRight: Radius.circular(32),
                                          )),
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                          child: CreateNewServicePage(
                                            serviceId: svc.id ?? "",
                                            isUpdate: true,
                                            salonService: svc,
                                          ),
                                        );
                                      });
                                },
                                price: svc.price?.toString() ?? "",
                                isHomeService: svc.homeService ?? false,
                                time: svc.duration?.toString() ?? "",
                                gender: svc.gender ?? "",
                                image: "${APIConstants.image}${svc.image ?? ""}",
                                name: svc.name ?? "",
                                category: svc.categories?[0].name?? "",
                              ),
                            );
                          });
                    }),
                  ],
                ),
              ),
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
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search and add service",
                hintStyle: AppTextTheme.regular.copyWith(
                    fontSize: 16, color: ColorConstant.grayTextColor),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
