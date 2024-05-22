import 'dart:ui';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/stylist_home_api.dart';
import 'package:salon/model/stylist/appoimrnt_details_model.dart';
import 'package:salon/model/stylist/pending_appointment.dart';

class StylistController extends GetxController {
  /*---------------  Show  Progressbar --------------*/
  final Rx<bool> _showProgress = false.obs;
  bool get showProgress => _showProgress.value;
  set setShowProgress(val) => _showProgress.value = val;

  /*------------------- Store PendingAppointmentsListModel -------------*/
  final Rx<PendingAppointmentsListModel> _pendingAppointmentsListModel =
      PendingAppointmentsListModel().obs;
  PendingAppointmentsListModel get getPendingAppointmentsListModel =>
      _pendingAppointmentsListModel.value;
  set setPendingAppointmentsListModel(val) =>
      _pendingAppointmentsListModel.value = val;

  /*----------------- Accept Booking ---------------------------*/
  final Rx<PendingAppointmentsListModel> _acceptAppointmentsListModel =
      PendingAppointmentsListModel().obs;
  PendingAppointmentsListModel get getAcceptAppointmentsListModel =>
      _acceptAppointmentsListModel.value;
  set setAcceptAppointmentsListModel(val) =>
      _acceptAppointmentsListModel.value = val;

  /*-------------------- AppointmentsDetailsModel ---------------------------*/
  final Rx<AppointmentsDetailsModel> _appointmentsDetailsModel =
      AppointmentsDetailsModel().obs;
  AppointmentsDetailsModel get getAppointmentsDetailsModel =>
      _appointmentsDetailsModel.value;
  set setAppointmentsDetailsModel(val) => _appointmentsDetailsModel.value = val;

  /*---------------------- Get PendingAppointmentsListModel --------------------*/
  doPendingAppointmentsListModel() async {
    try {
      _showProgress.value = true;
      _pendingAppointmentsListModel.value = await StylistAPI.upcomingBooking();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------  Get  AcceptAppointment */
  doAcceptAppointment() async {
    try {
      _showProgress.value = true;
      _acceptAppointmentsListModel.value = await StylistAPI.acceptBooking();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------- Get Accept Booking ---------------------*/

  /*---------------------- Get  AppointmentsDetailsModel -------------------*/
  doAppointmentsDetailsModel({required String appointmentId}) async {
    try {
      _showProgress.value = true;
      _appointmentsDetailsModel.value =
          await StylistAPI.appointmentsDetails(appointmentId: appointmentId);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------------ Approve Booking  ------------------------*/
  doBookingApprove(
      {required String appointmentId,
      required String status,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result = await StylistAPI.approveBooking(
          appointmentId: appointmentId, status: status);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------------- Qr code To  Booking Page --------------*/
  doScanQrcode(
      {required String completionToken, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result =
          await StylistAPI.qrcodeScan(completionToken: completionToken);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }
}
