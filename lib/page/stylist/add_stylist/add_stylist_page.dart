import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../../constant/api_constant.dart';

class AddStylistPage extends StatefulWidget {
  final String artistId;
  final bool isBasicInfoUpdate;
  const AddStylistPage(
      {super.key, required this.artistId, required this.isBasicInfoUpdate});

  @override
  State<AddStylistPage> createState() => _AddStylistPageState();
}

class _AddStylistPageState extends State<AddStylistPage> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _experience = TextEditingController();
  final _password = TextEditingController();
  final _verificationCode = TextEditingController();
  final _sId = TextEditingController();

  final List<String> _languageOptions = [
    "english",
    "hindi",
    "kannada",
    "telugu",
    "tamil",
    "assamese",
    "bengali",
  ];
  final Set<String> _selectedLanguages = {};

  String gender = "";
  String profession = "";
  File imagePath = File("");
  final List<File> _dropImages = [File(""), File(""), File("")];
  bool isHomeServiceEnable = false;
  bool isOTPButton = false;
  bool isOTPField = false;
  bool _passwordObscure = true;
  int _start = 60;
  bool isResendOTp = false;

  final _phoneFocusNode = FocusNode();
  bool _isDummyPhone = true;

  final _authController = Get.find<AuthController>();
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus && _isDummyPhone) {
        _mobile.clear();
        setState(() {
          _isDummyPhone = false;
          isOTPButton = false;
          isOTPField = false;
          _verificationCode.clear();
        });
      }
    });
    if (widget.isBasicInfoUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _homeController.doGetArtiestDetails(
            artistId: widget.artistId,
            callback: () {
              _name.text =
                  _homeController.getArtiestDetailsModel.data?.name ?? "";
              _mobile.text =
                  _homeController.getArtiestDetailsModel.data?.mobile ?? "";
              _experience.text = _homeController
                      .getArtiestDetailsModel.data?.experience
                      .toString() ??
                  "";
              gender =
                  _homeController.getArtiestDetailsModel.data?.gender ?? "";
              isHomeServiceEnable =
                  _homeController.getArtiestDetailsModel.data?.homeService ??
                      false;
            });
      });
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _generateSIdAndPhone());
    }
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    super.dispose();
  }

  Future<void> _generateSIdAndPhone() async {
    final allStaff = await _homeController.doGetAllSalonStaffList();
    final staffList = allStaff.data ?? [];
    final existingSIds = staffList.map((s) => s.sId ?? "").toSet();
    final existingPhones = staffList.map((s) => s.phone ?? "").toSet();
    final rng = Random();

    String sidCandidate;
    do {
      final digits = 100000 + rng.nextInt(900000);
      sidCandidate = "SID$digits";
    } while (existingSIds.contains(sidCandidate));

    String phoneCandidate;
    do {
      // Generate a valid 10-digit mobile number starting with 6–9
      final prefix = 6 + rng.nextInt(4); // 6, 7, 8 or 9
      final rest = rng.nextInt(1000000000).toString().padLeft(9, '0');
      phoneCandidate = "$prefix$rest";
    } while (existingPhones.contains(phoneCandidate));

    if (mounted) {
      setState(() {
        _sId.text = sidCandidate;
        _mobile.text = phoneCandidate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Add Stylist",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          // _countRowWidget(),
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : ListView(
                      padding: const EdgeInsets.only(top: 20),
                      children: [
                        _stylistProfilePhoto(),
                        const SizedBox(height: 20),
                        _styledField(
                            controller: _name,
                            hint: "Enter the Name of Stylist",
                            label: "Stylist Name",
                            inputType: TextInputType.text),
                        const SizedBox(height: 20),
                        if (!widget.isBasicInfoUpdate) _sIdField(),
                        _mobileNumberWidget(
                            textEditingController: _mobile,
                            hintText: "Enter Here",
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            title: "Phone Number"),
                        const SizedBox(height: 20),
                        if (isOTPField) _otpField(),
                        if (isOTPField) const SizedBox(height: 20),
                        if (!widget.isBasicInfoUpdate)
                          _styledPasswordField(
                              controller: _password,
                              hint: "Enter the Password for stylist profile",
                              label: "Password"),
                        if (!widget.isBasicInfoUpdate)
                          const SizedBox(height: 20),
                        _selectGender(),
                        const SizedBox(height: 20),
                        _selectProfession(),
                        const SizedBox(height: 20),
                        _languagesKnown(),
                        const SizedBox(height: 20),
                        _dropImagesSection(),
                        const SizedBox(height: 25),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ButtonWidget(
                buttonTitleText: widget.isBasicInfoUpdate ? "Update" : "Add",
                onPress: () {
                  widget.isBasicInfoUpdate
                      ? _doUpdateStylist()
                      : _doAddStylist();
                }),
          )
        ],
      ),
    );
  }

  /*---------------- SId Field ----------------*/
  Widget _sIdField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SId",
            style: AppTextTheme.semibold
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstant.borderColor),
              color: ColorConstant.lightColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: _sId,
              readOnly: true,
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Generating...",
                hintStyle: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayColor, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /*---------------- Add Stylist Logic ----------------*/
  _doAddStylist() {
    if (_name.text.isEmpty) return showMessage("Please enter stylist name");
    if (_sId.text.isEmpty)
      return showMessage("Stylist ID is being generated, please wait");
    if (_mobile.text.isEmpty) return showMessage("Please enter phone number");
    if (_mobile.text.length != 10) {
      return showMessage("Please enter valid 10 digit phone number");
    }
    if (_password.text.isEmpty) return showMessage("Please enter password");
    if (_password.text.length < 8) {
      return showMessage("Password must be at least 8 characters long");
    }
    if (gender.isEmpty) return showMessage("Please select gender");
    if (profession.isEmpty) return showMessage("Please select profession");
    if (_selectedLanguages.isEmpty) {
      return showMessage("Please select at least one language");
    }
    if (imagePath.path.isEmpty)
      return showMessage("Please choose a profile image");

    _homeController.doAddArtiest(
        name: _name.text.trim(),
        mobile: _mobile.text.trim(),
        countryCode: "91",
        experience: _experience.text.trim(),
        whatsapp: _mobile.text.trim(),
        homeService: isHomeServiceEnable.toString(),
        password: _password.text,
        gender: gender,
        image: imagePath,
        portfolioFiles: _dropImages.where((f) => f.path.isNotEmpty).toList(),
        storeId: [],
        genderDataList: [],
        sId: _sId.text,
        profession: profession,
        languagesKnown: _selectedLanguages.toList(),
        callback: () {
          Get.back();
          _homeController.doSalonArtistList();
        });
  }

  /*---------------- Update Stylist Logic ----------------*/
  _doUpdateStylist() {
    if (_name.text.isEmpty) return showMessage("Please enter stylist name");
    if (_mobile.text.isEmpty) return showMessage("Please enter phone number");
    if (_mobile.text.length != 10) {
      return showMessage("Please enter valid 10 digit phone number");
    }
    if (gender.isEmpty) return showMessage("Please select gender");

    _homeController.doUpdateStylistBasicInfo(
        artistId: widget.artistId,
        name: _name.text,
        mobile: _mobile.text,
        countryCode: "91",
        experience: _experience.text,
        whatsapp: "9999999999",
        homeService: isHomeServiceEnable.toString(),
        gender: gender,
        image: imagePath,
        callback: () {
          Get.back();
          _homeController.doSalonArtistList();
        });
  }

  /*---------------- Mobile Number + OTP ----------------*/
  Widget _mobileNumberWidget({
    required TextEditingController textEditingController,
    required String hintText,
    required String title,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: AppTextTheme.semibold
                      .copyWith(fontSize: 13, color: ColorConstant.blackColor),
                ),
                if (!widget.isBasicInfoUpdate)
                  TextSpan(
                    text: "  (Give Stylist Number If you are okay with it)",
                    style: AppTextTheme.regular.copyWith(
                        fontSize: 11, color: ColorConstant.grayTextColor),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstant.borderColor),
              color: _isDummyPhone
                  ? ColorConstant.lightColor
                  : ColorConstant.whiteColor,
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text("+91",
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 13, color: ColorConstant.grayTextColor)),
                const SizedBox(width: 5),
                SizedBox(
                  width: Get.width * 0.6,
                  child: TextField(
                    onChanged: (val) {
                      if (val.length == 10) {
                        setState(() => isOTPButton = true);
                      } else {
                        setState(() {
                          _verificationCode.clear();
                          isOTPButton = false;
                          isOTPField = false;
                        });
                      }
                    },
                    controller: textEditingController,
                    focusNode: _phoneFocusNode,
                    keyboardType: textInputType,
                    textInputAction: textInputAction,
                    maxLength: 10,
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      counterText: "",
                      hintStyle: AppTextTheme.medium.copyWith(
                          color: ColorConstant.grayColor, fontSize: 13),
                    ),
                  ),
                ),
                if (isOTPButton)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _authController.doSendArtiestOtp(
                            mobileNo: _mobile.text, callback: () {});
                        isOTPField = true;
                        _start = 60;
                        startTimer();
                      });
                    },
                    child: Text("Get OTP",
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13)),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _otpField() {
    return Column(
      children: [
        SimpleTextFieldWidget(
            onChanged: (val) {
              if (val.length == 6) {
                _authController.doVerifyArtiestOtp(
                    callback: () {}, mobileNo: _mobile.text, otp: val);
              }
            },
            textEditingController: _verificationCode,
            hintText: "",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            title: "Enter OTP"),
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              isResendOTp
                  ? TextButton(
                      onPressed: () {
                        setState(() {
                          _start = 60;
                          isResendOTp = false;
                          startTimer();
                          _authController.doSendOTP(
                              mobileNo: _mobile.text, cc: "91");
                          _verificationCode.clear();
                        });
                      },
                      child: Text("Resend",
                          style: AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.redColor)))
                  : Text("Retry in 00:${_start.toString()}",
                      style: AppTextTheme.bold.copyWith(
                          fontSize: 16, color: ColorConstant.redColor)),
            ],
          ),
        ),
      ],
    );
  }

  startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => isResendOTp = true);
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  /*---------------- Gender ----------------*/
  final List<String> dataList = ["MALE", "FEMALE", "UNISEX"];
  Widget _selectGender() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender",
              style: AppTextTheme.semibold
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            width: Get.width,
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: ColorConstant.primaryColor2, width: 1.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: ColorConstant.primaryColor2, width: 1.2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              hint: Text(
                widget.isBasicInfoUpdate ? gender : 'Select Gender',
                style: AppTextTheme.medium.copyWith(
                    color: widget.isBasicInfoUpdate
                        ? ColorConstant.blackColor
                        : ColorConstant.grayColor,
                    fontSize: 13),
              ),
              items: dataList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        onTap: () => gender = item,
                        child: Text(item,
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blackColor, fontSize: 13)),
                      ))
                  .toList(),
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Styled plain text field ----------------*/
  Widget _styledField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required TextInputType inputType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextTheme.semibold
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: ColorConstant.primaryColor2, width: 1.2),
            ),
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 13),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayColor, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Styled password field ----------------*/
  Widget _styledPasswordField({
    required TextEditingController controller,
    required String hint,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextTheme.semibold
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            obscureText: _passwordObscure,
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 13),
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              hintText: hint,
              hintStyle: AppTextTheme.medium
                  .copyWith(color: ColorConstant.grayColor, fontSize: 13),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordObscure ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: ColorConstant.grayTextColor,
                ),
                onPressed: () =>
                    setState(() => _passwordObscure = !_passwordObscure),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: ColorConstant.primaryColor2, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: ColorConstant.primaryColor2, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Profession (radio buttons) ----------------*/
  final List<Map<String, String>> _professionOptions = const [
    {'value': 'HAIR', 'label': 'Hair Stylist'},
    {'value': 'BEAUTICIAN', 'label': 'Beautician'},
    {'value': 'BOTH', 'label': 'Both'},
  ];

  Widget _selectProfession() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Profession",
              style: AppTextTheme.semibold
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 14),
          Row(
            children: _professionOptions.map((opt) {
              final isSelected = profession == opt['value'];
              return GestureDetector(
                onTap: () => setState(() => profession = opt['value']!),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ColorConstant.primaryColor2, width: 2),
                          color: isSelected
                              ? ColorConstant.primaryColor2
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 13, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(opt['label']!,
                          style: AppTextTheme.semibold.copyWith(
                              color: ColorConstant.primaryColor, fontSize: 13)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /*---------------- Languages Known (chips) ----------------*/
  Widget _languagesKnown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Languages Know",
              style: AppTextTheme.semibold
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _languageOptions.map((lang) {
              final isSelected = _selectedLanguages.contains(lang);
              return GestureDetector(
                onTap: () => setState(() => isSelected
                    ? _selectedLanguages.remove(lang)
                    : _selectedLanguages.add(lang)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorConstant.primaryColor2
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(lang,
                      style: AppTextTheme.medium.copyWith(
                          color: isSelected
                              ? ColorConstant.whiteColor
                              : ColorConstant.blackColor,
                          fontSize: 13)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /*---------------- Drop Images Or Videos ----------------*/
  Widget _dropImagesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Drop Images Or Videos",
              style: AppTextTheme.semibold
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 14),
          Row(
            children: List.generate(3, (index) {
              final file = _dropImages[index];
              return Expanded(
                child: GestureDetector(
                  onTap: () => FileUtils.openPlatformImagePicker(
                      onSelectImage: (picked) =>
                          setState(() => _dropImages[index] = picked)),
                  child: Container(
                    height: 110,
                    margin: EdgeInsets.only(right: index < 2 ? 10 : 0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: file.path.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(file, fit: BoxFit.cover),
                          )
                        : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /*---------------- Profile Photo ----------------*/
  Widget _stylistProfilePhoto() {
    return GestureDetector(
      onTap: () {
        FileUtils.openPlatformImagePicker(onSelectImage: (file) {
          setState(() => imagePath = file);
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          imagePath.path == ""
              ? widget.isBasicInfoUpdate
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageUrl:
                            "${APIConstants.image}${_homeController.getArtiestDetailsModel.data?.profileImage ?? ""}",
                        placeholder: (context, url) => const Image(
                            image: AssetImage(AssetsConstant.placeHolder)),
                        errorWidget: (context, url, error) => const Image(
                            image: AssetImage(AssetsConstant.placeHolder)),
                      ),
                    )
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: ColorConstant.grayTextColor.withOpacity(0.3),
                          shape: BoxShape.circle),
                    )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(imagePath,
                      width: 100, height: 100, fit: BoxFit.cover),
                ),
          Positioned(
            bottom: 10,
            left: 70,
            right: 0,
            child: Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: ColorConstant.whiteColor, shape: BoxShape.circle),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: ColorConstant.editButtonColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.editIcon,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Stepper Header ----------------*/
  Widget _countRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: const Center(
                    child: Text("1",
                        style: TextStyle(color: Colors.white, fontSize: 14))),
              ),
              Container(
                  height: 2, width: 80, color: ColorConstant.primaryColor),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorConstant.primaryColor)),
              ),
              Container(
                  height: 2, width: 80, color: ColorConstant.grayTextColor),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorConstant.grayTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("basic info",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Select Service",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Review",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Message Function ----------------*/
  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
