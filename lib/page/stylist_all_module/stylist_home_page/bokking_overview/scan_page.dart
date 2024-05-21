import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_scanner_with_effect/qr_scanner_with_effect.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.whiteColor,
        appBar: const AppBarWidget(
          nameOfScreen: "Scan",
          isBackIcon: true,
        ),
        body: Stack(
          children: [
            QrScannerWithEffect(
              isScanComplete: isComplete,
              qrKey: qrKey,
              onQrScannerViewCreated: onQrScannerViewCreated,
              qrOverlayBorderColor: Colors.redAccent,
              cutOutSize: (MediaQuery.of(context).size.width < 300 ||
                      MediaQuery.of(context).size.height < 400)
                  ? 250.0
                  : 300.0,
              onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
              effectGradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1],
                colors: [
                  Colors.redAccent,
                  Colors.redAccent,
                ],
              ),
            ),
            Positioned(
              bottom: Get.height * 0.14,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "OR",
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.whiteColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter manually",
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.whiteColor),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: ColorConstant.whiteColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          "Enter Here",
                          style: AppTextTheme.regular
                              .copyWith(color: ColorConstant.whiteColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Barcode? result;
  QRViewController? controller;

  bool isComplete = false;

  void onQrScannerViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      controller.pauseCamera();

      await Future<void>.delayed(const Duration(milliseconds: 300));

      String? myQrCode =
          result?.code != null && result!.code.toString().isNotEmpty
              ? result?.code.toString()
              : '';
      if (myQrCode != null && myQrCode.isNotEmpty) {
        manageQRData(myQrCode);
        print(myQrCode);
      }
    });
  }

  void manageQRData(String myQrCode) async {
    controller?.stopCamera();
    setState(() {
      isComplete = true;
    });
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
    super.reassemble();
  }

  @override
  void dispose() {
    controller?.dispose();
    controller?.stopCamera();
    super.dispose();
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
