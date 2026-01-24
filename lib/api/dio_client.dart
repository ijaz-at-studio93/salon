import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../constant/api_constant.dart';
import '../util/shared_prefs.dart';
import 'dio_connectivity_request_retrier.dart';
import 'dio_interceptors.dart';

export 'package:salon/util/extensions.dart' show DioResponseExtension;

class DioClient {
  static CancelToken? cancelToken;
  static Dio? _dio;

  static Dio get client {
    return Get.find<Dio>();
  }

  static init() {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: APIConstants.baseUrl,
        validateStatus: (status) {
          return status! <= 500;
        },
        headers: {
          'Accept': 'application/json',
        },
      ));

      _dio!.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          request: true,
          responseHeader: false,
          compact: false,
        ),
      );

      _dio!.interceptors.add(
        InterceptorsWrapper(onRequest:
            (RequestOptions req, RequestInterceptorHandler handler) async {
          String token = SharedPrefs.readStringValue(PrefConstants.token);
          debugPrint("Bearer $token");
          debugPrint('DioClientPrint');
          if (token.isNotEmpty) {
            req.headers['Authorization'] = 'Bearer $token';
            req.headers['x-access-token'] = token;
          }
          return handler.next(req);
        }, onResponse:
            (Response<dynamic> resp, ResponseInterceptorHandler handler) async {
          try {
            if (resp.statusCode == 403 || resp.statusCode == 401) {
              Get.find<AuthController>().resetApp();
            }
            if (resp.statusCode == 500) {
              showMessage("Please wait server under maintenance");
            }
          } catch (e) {
            return handler.next(resp);
          }
          return handler.next(resp);
        }, onError:
            (DioException error, ErrorInterceptorHandler handler) async {
          return handler.next(error);
        }),
      );

      _dio!.interceptors.add(RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: _dio!,
          connectivity: Connectivity(),
        ),
      ));
    }
    Get.put(_dio!, permanent: true);
  }

  static Map<String, String> get headers {
    String? token = SharedPrefs.readStringValue(PrefConstants.token);
    if (token.isNotEmpty) {
      return {'Authorization': 'Bearer $token'};
    } else {
      return {};
    }
  }
}

Future<void> showError(error) async {
  String message = "Error";
  try {
    if (error is DioException) {
      if (error.type == DioExceptionType.cancel) {
        return;
      } else {
        message = "API Error";
      }
    } else if (error is PlatformException) {
      message = "Platform Error";
    } else if (error.containsKey('response') &&
        error['response'] != null &&
        error['response']['appointment'] != null) {
      message = error['response']['appointment'];
    } else {
      message = error['message'];
    }
    showMessage(message);
  } catch (e) {
    showMessage(message);
  }
}

Future<void> showMessage(String message, {int duration = 2}) async {
  if (Get.context != null) {
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        message.isEmpty ? "Error" : message,
        style: AppTextTheme.medium
            .copyWith(fontSize: 15, color: ColorConstant.whiteColor),
      ),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(12),
      duration: Duration(seconds: duration),
      borderRadius: 16,
    ));
  }
}

void showSnackBar({
  String? title,
  required String message,
}) {
  if (Get.context != null) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text(
          '$message}',
          style: TextStyle(
            color: Colors.purple.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.purple.shade100, // soft background
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }
}
