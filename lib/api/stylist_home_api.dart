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
    final response =
        await DioClient.client.get("artist/appointments/upcoming/confirm-appointments");
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
}
