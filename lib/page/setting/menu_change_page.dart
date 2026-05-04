import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/home_api.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/shared_prefs.dart';

class MenuChangePage extends StatefulWidget {
  const MenuChangePage({super.key});

  @override
  State<MenuChangePage> createState() => _MenuChangePageState();
}

class _MenuChangePageState extends State<MenuChangePage> {
  String? _selectedFilePath;
  String? _selectedFileName;

  /// After submit succeeds, UI switches to the design’s centered-only screen.
  /// Read from cache first so reopening the screen does not flash the upload UI.
  bool _uploadComplete = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _uploadComplete = false;
    _checkExistingRequest();
  }

  Future<void> _checkExistingRequest() async {
    try {
      final exists = await HomeAPI.getMenuChangeRequest();
      if (!mounted) return;

      // await SharedPrefs.writeValue(
      //     PrefConstants.menuChangeRequestSubmitted, exists);

      print('))))))))))))))))))))');
      print(exists);

      // ✅ ALWAYS update UI
      setState(() => _uploadComplete = exists);
    } catch (_) {
      if (!mounted) return;

      // ✅ safe fallback
      setState(() => _uploadComplete = false);
    }
  }

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

  Future<void> _submit() async {
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
    setState(() => _isLoading = true);
    try {
      await HomeAPI.submitMenuChangeRequest(filePath: _selectedFilePath!);
      if (!mounted) return;
      // await SharedPrefs.writeValue(
      //     PrefConstants.menuChangeRequestSubmitted, true);
      if (!mounted) return;
      setState(() => _uploadComplete = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Menu change request submitted',
            style:
                AppTextTheme.regular.copyWith(color: ColorConstant.whiteColor),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to submit request. Please try again.',
            style:
                AppTextTheme.regular.copyWith(color: ColorConstant.whiteColor),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  Widget _filePreview() {
    final isImage = _selectedFileName!
        .toLowerCase()
        .endsWith('.jpg') ||
        _selectedFileName!.toLowerCase().endsWith('.jpeg');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 260,
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 320),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: isImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_selectedFilePath!),
                  fit: BoxFit.cover,
                ),
              )
                  : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.picture_as_pdf,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      'PDF File',
                      style: AppTextTheme.medium,
                    ),
                  ],
                ),
              ),
            ),

            /// ❌ REMOVE BUTTON
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilePath = null;
                  _selectedFileName = null;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.close,
                    color: Colors.white, size: 18),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          _selectedFileName!,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.medium.copyWith(
            color: ColorConstant.bookingCardBorderPurple,
            fontSize: 14,
          ),
        ),
      ],
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
                child: _selectedFilePath != null
                    ? _filePreview()
                    : _menuChangeCenteredView(),
              ),
            ),
          ),
          // if (_selectedFileName != null) ...[
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 32),
          //     child: Text(
          //       _selectedFileName!,
          //       textAlign: TextAlign.center,
          //       maxLines: 2,
          //       overflow: TextOverflow.ellipsis,
          //       style: AppTextTheme.medium.copyWith(
          //         color: ColorConstant.bookingCardBorderPurple,
          //         fontSize: 14,
          //       ),
          //     ),
          //   ),
          //   const SizedBox(height: 12),
          // ],
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
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ColorConstant.bookingCardBorderPurple,
                  foregroundColor: ColorConstant.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
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
