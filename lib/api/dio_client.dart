import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:salon/controller/auth_controller.dart';

import '../constant/api_constant.dart';
import '../util/app_snackbar.dart';
import '../util/shared_prefs.dart';
import 'auth_api.dart';
import 'dio_connectivity_request_retrier.dart';
import 'dio_interceptors.dart';

export 'package:salon/util/extensions.dart' show DioResponseExtension;

class DioClient {
  static CancelToken? cancelToken;
  static Dio? _dio;

  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;

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

            /// ------------------------------------------------
            /// 🔥 ACCESS TOKEN EXPIRED (401 / 403)
            /// ------------------------------------------------
            if (statusCode == 401 || statusCode == 403) {
              try {
                final RequestOptions requestOptions = error.requestOptions;

                /// Prevent infinite retry loop
                if (requestOptions.extra["retried"] == true) {
                  return handler.next(error);
                }

                bool refreshSuccess;

                if (!_isRefreshing) {
                  // This request owns the refresh — others will await its Completer
                  _isRefreshing = true;
                  _refreshCompleter = Completer<bool>();

                  bool result = false;
                  try {
                    result = await AuthAPI.refreshAccessToken();
                  } catch (_) {
                    result = false;
                  }

                  _isRefreshing = false;
                  _refreshCompleter!.complete(result);
                  _refreshCompleter = null;
                  refreshSuccess = result;
                } else {
                  // Another request is already refreshing — await its result
                  refreshSuccess = await _refreshCompleter!.future;
                }

                if (!refreshSuccess) {
                  Get.find<AuthController>().resetApp();
                  return handler.next(error);
                }

                /// Retry original request with the new token
                final String newToken =
                    SharedPrefs.readStringValue(PrefConstants.token);
                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                requestOptions.headers['x-access-token'] = newToken;
                requestOptions.extra["retried"] = true;

                final Response retryResponse =
                    await _dio!.fetch(requestOptions);
                return handler.resolve(retryResponse);
              } catch (e) {
                // Transient error during refresh (e.g. SocketException) — do NOT logout
                _isRefreshing = false;
                if (_refreshCompleter != null &&
                    !_refreshCompleter!.isCompleted) {
                  _refreshCompleter!.complete(false);
                  _refreshCompleter = null;
                }
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
        message = error.response?.data['message'] ?? "API Error";
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
  showDioStyleSnackBar(
    message.isEmpty ? "Error" : message,
    duration: duration,
  );
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
