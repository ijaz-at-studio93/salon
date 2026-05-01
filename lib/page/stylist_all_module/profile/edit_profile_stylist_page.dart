import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon/api/auth_api.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/artist_model/artist_login_model.dart';
import 'package:salon/project_specific/phone_field_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../constant/assetsconstant.dart';
import '../../stylist/stylist_about_page.dart';

/// National-dialling digits only, e.g. `91` for India.
String _dialDigits(String? code) {
  final d = (code ?? '91').trim().replaceAll(RegExp(r'\D'), '');
  return d.isEmpty ? '91' : d;
}

class EditProfileStylistPage extends StatefulWidget {
  const EditProfileStylistPage({super.key});

  @override
  State<EditProfileStylistPage> createState() => _EditProfileStylistPageState();
}

class _EditProfileStylistPageState extends State<EditProfileStylistPage> {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(nameOfScreen: "Profile"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.05),
                  _stylistProfilePhoto(),
                  SizedBox(height: Get.height * 0.05),
                  _profileRowWidget(
                      title: "Full Name",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.name ??
                          ""),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Email",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.email ??
                          ""),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Gender",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.gender ??
                          ""),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  /* _profileRowWidget(
                      title: "Date Of Birth", subTitle: _authController.getSalonArtistResponseModel.data?.salonArtistData?.),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),*/
                  _mobileNumberRow(),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Date Of Birth",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.dob ??
                          ""),
                  /* const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Can Do", subTitle: "${_authController.getSalonArtistResponseModel.data?.salonArtistData?.homeService}"),*/
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Portfolio",
                          textScaler: const TextScaler.linear(0.85),
                          style: AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const StylistAboutPage());
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  "See Activity",
                                  textScaler: const TextScaler.linear(0.85),
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.primaryColor),
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  AssetsConstant.arrowShare,
                                  height: 13,
                                  width: 13,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ButtonWidget(buttonTitleText: "Save", onPress: () {}),
          )*/
        ],
      ),
    );
  }

  /*----------- Profile Photo -------------*/
  File imagePath = File("");
  _stylistProfilePhoto() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        imageUrl:
            "${APIConstants.image}${_authController.getSalonArtistResponseModel.data?.salonArtistData?.profileImage ?? ""}",
        placeholder: (context, url) => const Image(
          image: AssetImage(AssetsConstant.placeHolder),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => const Image(
          image: AssetImage(AssetsConstant.placeHolder),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
    /*GestureDetector(
      onTap: () {
        FileUtils.openPlatformImagePicker(onSelectImage: (file) {
          setState(() {
            imagePath = file;
          });
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          imagePath.path == ""
              ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              imageUrl:
              "${APIConstants.image}${_authController.getSalonArtistResponseModel.data?.salonArtistData?.profileImage ?? ""}",
              placeholder: (context, url) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          )
              : Positioned(
            bottom: -5,
            left: 70,
            right: 0,
            child: Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: ColorConstant.whiteColor,
                  shape: BoxShape.circle),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: ColorConstant.editButtonColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.editIcon,
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )*/
  }

  /*---------------------  Mobile + edit (OTP + save) ---------------*/
  Widget _mobileNumberRow() {
    final d = _authController.getSalonArtistResponseModel.data?.salonArtistData;
    final dial = _dialDigits(d?.countryCode);
    final mobile = d?.mobile ?? "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Mobile Number",
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.medium
                .copyWith(fontSize: 16, color: ColorConstant.grayTextColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              mobile.isEmpty ? "—" : "+$dial $mobile",
              textAlign: TextAlign.end,
              textScaler: const TextScaler.linear(0.85),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bold
                  .copyWith(fontSize: 16, color: ColorConstant.blackColor),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 4),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: _showChangeMobileDialog,
            icon: Image.asset(
              AssetsConstant.editIcon,
              width: 18,
              height: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _applyUpdatedMobileToSession(
      String newMobile, String countryDialDigits) {
    final m = SalonArtistResponseModel.fromJson(
        _authController.getSalonArtistResponseModel.toJson());
    m.data?.salonArtistData?.mobile = newMobile;
    m.data?.salonArtistData?.whatsapp = newMobile;
    m.data?.salonArtistData?.countryCode = countryDialDigits;
    _authController.userArtiestDataStoreToSharedPrefs(m);
  }

  void _showChangeMobileDialog() {
    final artist =
        _authController.getSalonArtistResponseModel.data?.salonArtistData;
    final artistId = artist?.id;
    if (artistId == null || artistId.isEmpty) {
      showMessage("Could not load profile. Try again.");
      return;
    }

    Get.dialog(
      _UpdateMobileNumberDialog(
        artist: artist,
        artistId: artistId,
        onMobileSaved: (raw, cc) {
          _applyUpdatedMobileToSession(raw, cc);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              setState(() {});
              showMessage("Mobile number updated", duration: 3);
            });
          });
        },
      ),
      barrierDismissible: false,
    );
  }

  /*---------------------  Widget For Data  For Row Widget ---------------*/
  _profileRowWidget({required String title, required String subTitle}) {
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

class _UpdateMobileNumberDialog extends StatefulWidget {
  final SalonArtistData? artist;
  final String artistId;
  final void Function(String raw, String countryDialDigits) onMobileSaved;

  const _UpdateMobileNumberDialog({
    required this.artist,
    required this.artistId,
    required this.onMobileSaved,
  });

  @override
  State<_UpdateMobileNumberDialog> createState() =>
      _UpdateMobileNumberDialogState();
}

class _UpdateMobileNumberDialogState extends State<_UpdateMobileNumberDialog> {
  late final TextEditingController _mobileCtrl;
  late final TextEditingController _otpCtrl;
  final HomeController _homeController = Get.find<HomeController>();

  bool _showOtp = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _mobileCtrl = TextEditingController();
    _otpCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final artist = widget.artist;
    final raw = _mobileCtrl.text.trim();
    if (raw.isEmpty) {
      showMessage("Please enter mobile number");
      return;
    }
    if (raw.length != 10) {
      showMessage("Please enter a valid 10 digit mobile number");
      return;
    }
    if (raw == (artist?.mobile ?? "")) {
      showMessage("This is already your mobile number");
      return;
    }
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      final ok = await AuthAPI.artistSendVerification(mobileNo: raw);
      if (ok) {
        if (mounted) setState(() => _showOtp = true);
        showMessage("OTP sent");
      }
    } catch (e) {
      showError(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _verifyAndSave() async {
    final artist = widget.artist;
    final raw = _mobileCtrl.text.trim();
    final otp = _otpCtrl.text.trim();
    if (raw.length != 10) {
      showMessage("Please enter a valid 10 digit mobile number");
      return;
    }
    if (otp.length != 6) {
      showMessage("Please enter the 6 digit OTP");
      return;
    }
    if (!mounted) return;
    setState(() => _busy = true);
    var savedOk = false;
    try {
      await AuthAPI.artistOtpVerification(mobileNo: raw, otp: otp);

      final name = artist?.name ?? "";
      final exp = artist?.experience?.toString() ?? "0";
      final gender = artist?.gender ?? "";
      final homeSvc = (artist?.homeService ?? false).toString();
      final cc = _dialDigits(artist?.countryCode);

      await _homeController.doUpdateStylistBasicInfo(
        artistId: widget.artistId,
        name: name,
        mobile: raw,
        countryCode: cc,
        experience: exp,
        whatsapp: raw,
        homeService: homeSvc,
        gender: gender,
        image: File(""),
        callback: () {
          savedOk = true;
          Get.back();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onMobileSaved(raw, cc);
          });
        },
      );
    } catch (e) {
      showError(e);
    }
    if (!savedOk && mounted) {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final artist = widget.artist;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Update mobile number",
                style: AppTextTheme.bold.copyWith(
                  fontSize: 18,
                  color: ColorConstant.blackColor,
                ),
              ),
              const SizedBox(height: 16),
              PhoneFieldWidget(
                textEditingController: _mobileCtrl,
                hintText: "10 digit number",
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                title: "New mobile number",
                horizontalPadding: 0,
                countryCallingCode: _dialDigits(artist?.countryCode),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: _busy ? null : _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primaryColor,
                    foregroundColor: ColorConstant.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _busy && !_showOtp
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorConstant.whiteColor,
                          ),
                        )
                      : Text(
                          "Get OTP",
                          style: AppTextTheme.bold.copyWith(
                            fontSize: 15,
                            color: ColorConstant.whiteColor,
                          ),
                        ),
                ),
              ),
              if (_showOtp) ...[
                const SizedBox(height: 16),
                SimpleTextFieldWidget(
                  textEditingController: _otpCtrl,
                  hintText: "",
                  textInputType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  title: "Enter OTP",
                  horizontalPadding: 0,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _busy
                        ? null
                        : () async {
                            _otpCtrl.clear();
                            await _sendOtp();
                          },
                    child: Text(
                      "Resend OTP",
                      style: AppTextTheme.bold.copyWith(
                        fontSize: 14,
                        color: ColorConstant.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _verifyAndSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primaryColor,
                      foregroundColor: ColorConstant.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _busy && _showOtp
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorConstant.whiteColor,
                            ),
                          )
                        : Text(
                            "Verify & save",
                            style: AppTextTheme.bold.copyWith(
                              fontSize: 15,
                              color: ColorConstant.whiteColor,
                            ),
                          ),
                  ),
                ),
              ],
              TextButton(
                onPressed: _busy ? null : () => Get.back(),
                child: Text(
                  "Cancel",
                  style: AppTextTheme.medium.copyWith(
                    fontSize: 15,
                    color: ColorConstant.grayTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
