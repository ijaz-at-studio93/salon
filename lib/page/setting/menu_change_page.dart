import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class MenuChangePage extends StatefulWidget {
  const MenuChangePage({super.key});

  @override
  State<MenuChangePage> createState() => _MenuChangePageState();
}

class _MenuChangePageState extends State<MenuChangePage> {
  String? _selectedFilePath;
  String? _selectedFileName;

  /// After submit succeeds, UI switches to the design’s centered-only screen.
  bool _uploadComplete = false;

  Future<void> _pickMenuFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg'],
    );
    if (!mounted) return;
    if (result != null && result.files.isNotEmpty) {
      final f = result.files.single;
      setState(() {
        _selectedFilePath = f.path;
        _selectedFileName = f.name;
      });
    }
  }

  void _submit() {
    if (_selectedFilePath == null || _selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a PDF or JPEG file first',
            style:
                AppTextTheme.regular.copyWith(color: ColorConstant.whiteColor),
          ),
        ),
      );
      return;
    }
    // TODO: call upload API with _selectedFilePath; on success:
    setState(() {
      _uploadComplete = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Menu change request submitted',
          style: AppTextTheme.regular.copyWith(color: ColorConstant.whiteColor),
        ),
      ),
    );
  }

  /// Figma-aligned block: purple cloud + primary + secondary copy only.
  Widget _menuChangeCenteredView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsConstant.menuChangeCloudIcon,
            width: 140,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 24),
          Text(
            'Drop Your Latest Menu',
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.extraBold.copyWith(
              color: ColorConstant.grayTextColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '(Pdf Or Jpeg)',
            textAlign: TextAlign.center,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.regular.copyWith(
              color: ColorConstant.idColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadComplete) {
      return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: const AppBarWidget(
          nameOfScreen: 'Menu Change',
          isBackIcon: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AssetsConstant.timeLeftIcon,
                  width: 160,
                  height: 160,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                Text(
                  'Successfully Uploaded\nOur Team Will Get in Touch With You',
                  textAlign: TextAlign.center,
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: 'Menu Change',
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _pickMenuFile,
                child: _menuChangeCenteredView(),
              ),
            ),
          ),
          if (_selectedFileName != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _selectedFileName!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.medium.copyWith(
                  color: ColorConstant.bookingCardBorderPurple,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              16 + MediaQuery.paddingOf(context).bottom,
            ),
            child: SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ColorConstant.bookingCardBorderPurple,
                  foregroundColor: ColorConstant.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: AppTextTheme.extraBold.copyWith(
                    color: ColorConstant.whiteColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
