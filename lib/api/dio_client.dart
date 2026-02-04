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
import 'auth_api.dart';
import 'dio_connectivity_request_retrier.dart';
import 'dio_interceptors.dart';

export 'package:salon/util/extensions.dart' show DioResponseExtension;

class DioClient {
  static CancelToken? cancelToken;
  static Dio? _dio;

  static bool isRefreshing = false;

  static Dio get client {
    return Get.find<Dio>();
  }

  static init() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: APIConstants.baseUrl,

          /// Send only SUCCESS (2xx) to onResponse
          /// 401/403 will go to onError
          validateStatus: (status) {
            return status != null && status < 300;
          },
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      /// ===============================
      /// LOGGER
      /// ===============================
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

      /// ===============================
      /// AUTH + REFRESH INTERCEPTOR
      /// ===============================
      _dio!.interceptors.add(
        InterceptorsWrapper(
          /// ---------------------------
          /// REQUEST
          /// ---------------------------
          onRequest: (options, handler) async {
            if (options.extra['skipAuth'] == true) {
              return handler.next(options);
            }

            String token = SharedPrefs.readStringValue(PrefConstants.token);

            if (token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
              options.headers['x-access-token'] = token;
            }

            return handler.next(options);
          },

          /// ---------------------------
          /// RESPONSE
          /// ---------------------------
          onResponse: (response, handler) {
            if (response.statusCode == 500) {
              showMessage("Please wait server under maintenance");
            }
            return handler.next(response);
          },

          /// ---------------------------
          /// ERROR (REFRESH TOKEN FLOW)
          /// ---------------------------
          onError: (DioException error, ErrorInterceptorHandler handler) async {
            final int? statusCode = error.response?.statusCode;
            final String message =
                error.response?.data?['message']?.toString() ?? "";

            /// ------------------------------------------------
            /// 🚨 STOP LOOP IF TOKEN COMPLETELY INVALID
            /// ------------------------------------------------
            if (message == "Invalid authorization token") {
              isRefreshing = false;

              /// Logout user immediately
              Get.find<AuthController>().resetApp();

              return handler.next(error);
            }

            /// ------------------------------------------------
            /// 🔥 ACCESS TOKEN EXPIRED (401 / 403)
            /// ------------------------------------------------
            if (statusCode == 401 || statusCode == 403) {
              try {
                final RequestOptions requestOptions = error.requestOptions;

                /// ✅ Prevent infinite retry loop
                if (requestOptions.extra["retried"] == true) {
                  return handler.next(error);
                }

                /// Avoid multiple refresh calls
                if (!isRefreshing) {
                  isRefreshing = true;

                  await AuthAPI.refreshAccessToken();

                  isRefreshing = false;
                } else {
                  /// wait until refresh finishes
                  await Future.delayed(const Duration(milliseconds: 500));
                }

                /// ---------------------------
                /// RETRY ORIGINAL REQUEST
                /// ---------------------------
                String newToken =
                    SharedPrefs.readStringValue(PrefConstants.token);

                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                requestOptions.headers['x-access-token'] = newToken;

                /// Mark request as retried (VERY IMPORTANT)
                requestOptions.extra["retried"] = true;

                final Response retryResponse =
                    await _dio!.fetch(requestOptions);

                return handler.resolve(retryResponse);
              } catch (e) {
                isRefreshing = false;
                Get.find<AuthController>().resetApp();
                return handler.next(error);
              }
            }

            return handler.next(error);
          },
        ),
      );

      /// ===============================
      /// RETRY ON CONNECTION CHANGE
      /// ===============================
      _dio!.interceptors.add(
        RetryOnConnectionChangeInterceptor(
          requestRetrier: DioConnectivityRequestRetrier(
            dio: _dio!,
            connectivity: Connectivity(),
          ),
        ),
      );
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
