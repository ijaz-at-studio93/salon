import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:salon/project_specific/no_internet_connection.dart';
import '../controller/auth_controller.dart';
import 'dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({required this.requestRetrier});

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      try {
        // ─────────────────────────────────────────────────────────────────
        // Only enter the NoInternet / retry flow when the device genuinely
        // has no connectivity.  If the device is already online the problem
        // is the server (e.g. staging server down), NOT the local network.
        // Passing the error straight through prevents an infinite retry loop
        // where ConnectedGetBack keeps re-submitting a doomed request.
        // ─────────────────────────────────────────────────────────────────
        final connectivityResult =
            await requestRetrier.connectivity.checkConnectivity();
        final bool deviceIsOffline;
        if (connectivityResult is List) {
          deviceIsOffline = (connectivityResult as List<ConnectivityResult>)
              .every((r) => r == ConnectivityResult.none);
        } else {
          deviceIsOffline = connectivityResult == ConnectivityResult.none;
        }

        if (!deviceIsOffline) {
          // Device has internet — server is unreachable, not us.
          // Let the error propagate so the controller can show a message.
          return handler.next(err);
        }

        Get.find<AuthController>().setShowProgress = false;

        if (Get.find<AuthController>().isDialogShow) {
          Get.to(() => const NoInternetConnection());
          Get.find<AuthController>().setIsDialogShow = false;
        }
        Response response =
            await requestRetrier.scheduleRequestRetry(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        debugPrint(e.toString());
        debugPrint(e.runtimeType.toString());
        // Let any new error from the retrier pass through
      }
    }
    // Let the error pass through if it's not the error we're looking for
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionError ||
        err.error != null ||
        err.error is SocketException;
  }
}
