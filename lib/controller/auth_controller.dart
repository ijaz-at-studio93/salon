import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon/api/auth_api.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/model/artist_model/artist_login_model.dart';
import 'package:salon/model/auth/otp_verify_model.dart';
import 'package:salon/model/auth/salon_auth_model.dart';
import 'package:salon/page/auth/login_page.dart';
import '../util/shared_prefs.dart';

class AuthController extends GetxController {
  final Rx<bool> _showProgress = false.obs;
  bool get showProgress => _showProgress.value;
  set setShowProgress(val) => _showProgress.value = val;

  final Rx<bool> _isDialogShow = true.obs;
  bool get isDialogShow => _isDialogShow.value;
  set setIsDialogShow(val) => _isDialogShow.value = val;

  final Rx<bool> _isFavService = false.obs;
  bool get isFavService => _isFavService.value;
  set isFavServiceSelect(val) => _isFavService.value = val;

  final Rx<bool> _isSelectMenu = false.obs;
  bool get isSelectMenu => _isSelectMenu.value;
  set isSelectMenu(val) => _isSelectMenu.value = val;

  final Rx<bool> _isInsightsFav = false.obs;
  bool get isInsightsFav => _isInsightsFav.value;
  set isInsightsFavSelect(val) => _isInsightsFav.value = val;

/*--------------  Get Set Salon Address --------------*/
  final Rx<String> _salonCurrentAddress = "".obs;
  String get salonCurrentAddress => _salonCurrentAddress.value;
  set salonCurrentAddress(location) => _salonCurrentAddress.value = location;

  /*---------------------  Get Set Lat and Lng -----------------*/
  final Rx<double> _salonAddressLat = 0.0.obs;
  double get salonAddressLat => _salonAddressLat.value;
  set salonAddressLat(location) => _salonAddressLat.value = location;

  final Rx<double> _salonAddLan = 0.0.obs;
  double get salonAddressLan => _salonAddLan.value;
  set salonAddressLan(location) => _salonAddLan.value = location;

  /*------ Store OTP Model Data ------*/
  final Rx<OtpVerifyModel> _otpVerifyModelResponseModel = OtpVerifyModel().obs;
  OtpVerifyModel get otpVerifyModelResponseModel =>
      _otpVerifyModelResponseModel.value;
  set setOtpVerifyModelResponseModel(val) =>
      _otpVerifyModelResponseModel.value = val;

  /*------------------- Salon Auth Model --------------*/
  final Rx<SalonResponseModel> _salonResponseModel = SalonResponseModel().obs;
  SalonResponseModel get salonResponseModel => _salonResponseModel.value;
  set salonResponseModel(val) => _salonResponseModel.value = val;

  /*--------------------  Artiest Auth Model ------------------*/

  final Rx<SalonArtistResponseModel> _salonArtistResponseModel =
      SalonArtistResponseModel().obs;
  SalonArtistResponseModel get getSalonArtistResponseModel =>
      _salonArtistResponseModel.value;
  set setSalonArtistResponseModel(val) => _salonResponseModel.value = val;

  /*======================  Do  Register ===============*/
  doRegister({
    required String name,
    required String describe,
    required String email,
    required String countryCode,
    required String mobile,
    required String address,
    required String ownerName,
    required String ownerEmail,
    required String ownerCountryCode,
    required String ownerMobile,
    required String password,
    required String verificationCode,
    required String serviceOfferSlab,
    required String employeeSlab,
    required File? image,
    required String geolocationLat,
    required String geolocationLng,
    required String description,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      _salonResponseModel.value = await AuthAPI.doRegister(
          name: name,
          describe: describe,
          email: email,
          countryCode: countryCode,
          mobile: mobile,
          address: address,
          ownerName: ownerName,
          ownerEmail: ownerEmail,
          ownerCountryCode: ownerCountryCode,
          ownerMobile: ownerMobile,
          password: password,
          verificationCode: verificationCode,
          serviceOfferSlab: serviceOfferSlab,
          employeeSlab: employeeSlab,
          image: image,
          geolocationLat: geolocationLat,
          geolocationLng: geolocationLng,
          description: description);
      if (_salonResponseModel.value.data?.id != null) {
        userDataStoreToSharedPrefs(_salonResponseModel.value);
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------  do Login --------------------*/
  doLogin(
      {required String mobileNo,
      required String cc,
      required String password,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      _salonResponseModel.value = await AuthAPI.loginSalon(
          mobileNo: mobileNo, cc: cc, password: password);
      if (_salonResponseModel.value.data?.id != null) {
        userDataStoreToSharedPrefs(_salonResponseModel.value);
        callback.call();
      } else {
        showMessage(_salonResponseModel.value.message ?? "");
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------ User Data Store pref --------------*/
  Future<void> userDataStoreToSharedPrefs(SalonResponseModel model) async {
    _salonResponseModel.value = model;
    debugPrint(model.toString());
    if (model.data?.accessToken != null) {
      debugPrint("AccessTOKEN1:${model.data?.accessToken ?? ''}");
      await SharedPrefs.writeValue(
          PrefConstants.token, model.data?.accessToken);
    }
    await SharedPrefs.writeValue(PrefConstants.userModel, model.toJson());
    await SharedPrefs.writeValue(PrefConstants.isUserLogin, true);
  }

  Future<void> userDataStoreToArtiestSharedPrefs(
      SalonArtistResponseModel model) async {
    _salonArtistResponseModel.value = model;
    debugPrint(model.toString());
    if (model.data?.accessToken != null) {
      debugPrint("AccessTOKEN1:${model.data?.accessToken ?? ''}");
      await SharedPrefs.writeValue(
          PrefConstants.token, model.data?.accessToken);
    }
    await SharedPrefs.writeValue(PrefConstants.userModel, model.toJson());
    await SharedPrefs.writeValue(PrefConstants.isUserLogin, true);
  }

  /*---------------  init User Data -----------*/
  initUserData() async {
    if (SharedPrefs.readBoolValue(PrefConstants.isSalon)) {
      try {
        _showProgress.value = true;
        if (SharedPrefs.readBoolValue(PrefConstants.isUserLogin)) {
          _salonResponseModel.value = SalonResponseModel.fromJson(
              SharedPrefs.read(PrefConstants.userModel));
          userDataStoreToSharedPrefs(_salonResponseModel.value);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _showProgress.value = false;
      }
    } else {
      try {
        _showProgress.value = true;
        if (SharedPrefs.readBoolValue(PrefConstants.isUserLogin)) {
          _salonArtistResponseModel.value = SalonArtistResponseModel.fromJson(
              SharedPrefs.read(PrefConstants.stylistModel));
          userDataStoreToArtiestSharedPrefs(_salonArtistResponseModel.value);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        _showProgress.value = false;
      }
    }
  }

  /*================ Send OTP  Code ===============*/
  doSendOTP({required String mobileNo, required String cc}) async {
    try {
      _showProgress.value = true;
      bool result =
          await AuthAPI.sendVerificationCode(mobileNo: mobileNo, cc: cc);
      if (!result) {
        showMessage("Verification Code Send Success");
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*==========================  Verification Code =================*/
  doVerifyOtp(
      {required String mobileNO,
      required String cc,
      required String verificationCode}) async {
    try {
      _showProgress.value = true;
      _otpVerifyModelResponseModel.value = await AuthAPI.otpVerify(
          mobileNo: mobileNO, cc: cc, verificationCode: verificationCode);
      if (_otpVerifyModelResponseModel.value.data?.isVerificationCodeValid ??
          false) {
        showMessage(_otpVerifyModelResponseModel.value.message ?? "");
      } else {
        showMessage(_otpVerifyModelResponseModel.value.message ?? "");
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------- Artiest  --------------------- */
  doLoginArtiest(
      {required String mobileNo,
      required String cc,
      required String password,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      _salonArtistResponseModel.value = await AuthAPI.loginArtist(
          mobileNo: mobileNo, cc: cc, password: password);
      if (_salonArtistResponseModel.value.data?.id != null) {
        userArtiestDataStoreToSharedPrefs(_salonArtistResponseModel.value);
        callback.call();
      } else {
        showMessage(_salonArtistResponseModel.value.message ?? "");
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------- Artiest  Model  Data  Store ---------------------*/
  Future<void> userArtiestDataStoreToSharedPrefs(
      SalonArtistResponseModel model) async {
    _salonArtistResponseModel.value = model;
    debugPrint(model.toString());
    if (model.data?.accessToken != null) {
      debugPrint("AccessTOKEN1:${model.data?.accessToken ?? ''}");
      await SharedPrefs.writeValue(
          PrefConstants.token, model.data?.accessToken);
    }
    await SharedPrefs.writeValue(PrefConstants.stylistModel, model.toJson());
    await SharedPrefs.writeValue(PrefConstants.isUserLogin, true);
  }

/*------------------- RestAPP --------------*/
  resetApp() async {
    await SharedPrefs.writeValue(PrefConstants.isUserLogin, false);
    await SharedPrefs.writeValue(PrefConstants.isFirstTime, true);
    SharedPrefs.writeValue(PrefConstants.isSalon, false);
    SharedPrefs.writeValue(PrefConstants.isStylist, false);
    Get.offAll(() => const LoginPage());
  }
}
