import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/stylist_home_api.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/model/salon_review_model/salon_overall_review_model.dart';
import 'package:salon/model/stylist/appoimrnt_details_model.dart';
import 'package:salon/model/stylist/pending_appointment.dart';
import '../../model/stylist/allow_portfolio_upload_model.dart';

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

  /*-------------------  complete AppointmentsListModel --------------------*/
  final Rx<PendingAppointmentsListModel> _completeAppointmentsListModel =
      PendingAppointmentsListModel().obs;
  PendingAppointmentsListModel get getCompleteAppointmentsListModel =>
      _completeAppointmentsListModel.value;
  set setCompleteAppointmentsListModel(val) =>
      _completeAppointmentsListModel.value = val;

  /*------------------------- Complete Booking For QrCode ---------------------*/
  final Rx<AllowPortfolioUploadModel> _allowPortfolioUploadModel =
      AllowPortfolioUploadModel().obs;
  AllowPortfolioUploadModel get getAllowPortfolioUploadModel =>
      _allowPortfolioUploadModel.value;
  set setAllowPortfolioUploadModel(val) =>
      _allowPortfolioUploadModel.value = val;

  /*--------------- Artiest blog Add ------------------ */

  final Rx<BlogDataGetModel> _blogDataGetModelModel = BlogDataGetModel().obs;
  BlogDataGetModel get getBlogDataGetModelModel => _blogDataGetModelModel.value;
  set setBlogDataGetModelModel(val) => _blogDataGetModelModel.value = val;

  /*---------------------- Over all  Review Get ---------------*/
  final Rx<OverallReviewListModel> _overallStylistReviewListModel =
      OverallReviewListModel().obs;
  OverallReviewListModel get getOverallStylistReviewListModel =>
      _overallStylistReviewListModel.value;
  set setOverallStylistReviewListModel(val) =>
      _overallStylistReviewListModel.value = val;

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

  /*------------------------- Qr Code To Booking Page -------------------*/
  doScanQrcode(
      {required String completionToken, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      _allowPortfolioUploadModel.value =
          await StylistAPI.qrcodeScan(completionToken: completionToken);
      if (_allowPortfolioUploadModel.value.data?.appointment?.startsAt !=
              null ||
          _allowPortfolioUploadModel.value.data?.appointment?.startsAt != "") {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------- Do Get Served Booking ------------------*/
  doGetServedBooking() async {
    try {
      _showProgress.value = true;
      _completeAppointmentsListModel.value =
          await StylistAPI.servedBookingSection();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------- do Upload Image ------------------*/
  doUploadImage(
      {required String appointmentId,
      required List<String> multiplePath,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      String result = await StylistAPI.uploadImage(
          appointmentId: appointmentId, multiplePath: multiplePath);
      if (result != "") {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------- Do Blog Crate ----------------*/
  doCreateBlog({
    required String title,
    required String body,
    required String description,
    required File image,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await StylistAPI.addArtiestBlog(
          title: title, body: body, description: description, image: image);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------ Do Get Blog -----------------*/
  doGetBlog() async {
    try {
      _showProgress.value = true;
      _blogDataGetModelModel.value = await StylistAPI.getBlogList();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*---------------------------- Get  Over  All Stylist Review -------------*/
  doGetOverallStylistReview() async {
    try {
      _showProgress.value = true;
      _overallStylistReviewListModel.value =
          await StylistAPI.getOverAllStylistReview();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }
}
