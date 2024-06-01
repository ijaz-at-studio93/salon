import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:salon/model/stylist/allow_portfolio_upload_model.dart';
import 'package:salon/model/stylist/appoimrnt_details_model.dart';

import '../model/stylist/pending_appointment.dart';
import 'dio_client.dart';

class StylistAPI {
  /*---------------------------- Upcoming Booking Home APi --------------------------*/ static Future<
      PendingAppointmentsListModel> upcomingBooking() async {
    final response =
        await DioClient.client.get("artist/appointments/pending-appointments");
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*------------------------- Accepted Booking APi -------------------*/
  static Future<PendingAppointmentsListModel> acceptBooking() async {
    final response = await DioClient.client
        .get("artist/appointments/upcoming/confirm-appointments");
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-------------------------------  appointments id to get details ----------------------*/
  static Future<AppointmentsDetailsModel> appointmentsDetails(
      {required String appointmentId}) async {
    final response =
        await DioClient.client.get("artist/appointments/$appointmentId");
    if (response.isSuccess) {
      return AppointmentsDetailsModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-----------------------  Booking Approve -----------------------------*/
  static Future<bool> approveBooking(
      {required String appointmentId, required String status}) async {
    final response = await DioClient.client.put(
        "artist/appointments/$appointmentId/status",
        data: {"status": status});
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*---------------  Booking For Qr Code Scan ----------------*/
  static Future<AllowPortfolioUploadModel> qrcodeScan(
      {required String completionToken}) async {
    final response = await DioClient.client.put(
        "artist/appointments/complete-with-completion-token",
        data: {"completionToken": completionToken});
    if (response.data['success']) {
      return AllowPortfolioUploadModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*----------------------  Setting Section  Served Booking Section ---------------*/
  static Future<PendingAppointmentsListModel> servedBookingSection() async {
    final response =
        await DioClient.client.get("artist/appointments/served-appointments");
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-------------------- Upload Image */
  static Future<String> uploadImage(
      {required String appointmentId,
      required List<String> multiplePath}) async {
    final formData = FormData.fromMap({});

    if (multiplePath.isNotEmpty) {
      for (int i = 0; i < multiplePath.length; i++) {
        final mimeTypeData =
            lookupMimeType(multiplePath[i], headerBytes: [0xFF, 0xD8])
                ?.split('/');
        final multipartFile = await MultipartFile.fromFile(
            multiplePath[i] ?? "",
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        formData.files.add(MapEntry('images', multipartFile));
      }
    }

    final response = await DioClient.client.put(
        'artist/portfolio/appointments/$appointmentId/portfolio-upload',
        data: formData);
    if (response.isSuccess) {
      return response.data['message'];
    } else {
      throw response.data;
    }
  }
}
