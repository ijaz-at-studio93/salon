import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:salon/api/api_end_point.dart';
import 'package:salon/model/artist_model/artist_login_model.dart';
import 'package:salon/model/auth/otp_verify_model.dart';
import 'package:salon/model/auth/salon_auth_model.dart';
import 'package:salon/util/shared_prefs.dart';
import 'package:http_parser/http_parser.dart';
import 'dio_client.dart';

class AuthAPI {
  /*=============================== SALON ==================================*/

  /*--------------------- Login --------------------- */

  static Future<SalonResponseModel> doRegister({
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
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "describe": describe,
      "email": email,
      "countryCode": countryCode,
      "mobile": mobile,
      "address": address,
      "ownerName": ownerName,
      "ownerEmail": ownerEmail,
      "ownerCountryCode": ownerCountryCode,
      "ownerMobile": ownerMobile,
      "password": password,
      "verificationCode": verificationCode,
      "fcmToken": SharedPrefs.readStringValue(PrefConstants.fcmToken),
      "deviceId": SharedPrefs.readStringValue(PrefConstants.deviceId),
      "serviceOfferSlab": serviceOfferSlab,
      "employeeSlab": employeeSlab,
      "geolocationLat": geolocationLat,
      "geolocationLng": geolocationLng,
      "description": description
    });
    if (image != null) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }
    final response = await DioClient.client.post(
      APIEndPoint.salonRegister,
      data: formData,
    );

    if (response.isSuccess) {
      return SalonResponseModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*================ Login For Salon =============*/
  static Future<SalonResponseModel> loginSalon(
      {required String mobileNo,
      required String cc,
      required String password}) async {
    final response =
        await DioClient.client.post(APIEndPoint.salonLoginPassword, data: {
      "mobile": mobileNo,
      "countryCode": cc,
      "password": password,
      "fcmToken": SharedPrefs.readStringValue(PrefConstants.fcmToken),
      "deviceId": SharedPrefs.readStringValue(PrefConstants.deviceId),
    });
    if (response.isSuccess) {
      return SalonResponseModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*================= Send Verification Code ================*/
  static Future<bool> sendVerificationCode(
      {required String mobileNo, required String cc}) async {
    final response = await DioClient.client.post(
      APIEndPoint.salonSendVerificationCode,
      data: {
        "mobile": mobileNo,
        "countryCode": cc,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 203) {
      return response.data['data']['isRegistered'];
    } else {
      throw response.data;
    }
  }

  /*=================  Verify OTP ================*/
  static Future<OtpVerifyModel> otpVerify(
      {required String mobileNo,
      required String cc,
      required String verificationCode}) async {
    final response = await DioClient.client
        .post(APIEndPoint.verifyVerificationCode, data: {
      "mobile": mobileNo,
      "countryCode": cc,
      "verificationCode": verificationCode
    });

    if (response.isSuccess) {
      return OtpVerifyModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

/*=================================  END  SALON ====================================== */

/*===================================================  Artist  ===============================================*/
  static Future<SalonArtistResponseModel> loginArtist(
      {required String mobileNo,
      required String cc,
      required String password}) async {
    final response =
        await DioClient.client.post(APIEndPoint.salonArtiestLoginPassword, data: {
      "mobile": mobileNo,
      "countryCode": cc,
      "password": password,
      "fcmToken": SharedPrefs.readStringValue(PrefConstants.fcmToken),
      "deviceId": SharedPrefs.readStringValue(PrefConstants.deviceId),
    });
    if (response.isSuccess) {
      return SalonArtistResponseModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }
}
