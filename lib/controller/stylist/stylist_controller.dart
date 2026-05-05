import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/stylist_home_api.dart';
import 'package:salon/model/artist_model/artiest_dashboard_model.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/model/salon_review_model/salon_overall_review_model.dart';
import 'package:salon/model/stylist/appoimrnt_details_model.dart';
import 'package:salon/model/stylist/artist_portfolio_model.dart';
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

  /*------------------------- Take Pictures Button Visibility ---------------------*/
  final RxBool _shouldShowTakePicturesButton = false.obs;
  bool get shouldShowTakePicturesButton => _shouldShowTakePicturesButton.value;
  set setShouldShowTakePicturesButton(bool val) => _shouldShowTakePicturesButton.value = val;

  /*--------------- Artiest blog Add ------------------ */
  final Rx<BlogDataGetModel> _blogDataGetModelModel = BlogDataGetModel().obs;
  BlogDataGetModel get getBlogDataGetModelModel => _blogDataGetModelModel.value;
  set setBlogDataGetModelModel(val) => _blogDataGetModelModel.value = val;

  /*---------------  Get Artiest DashBoard --------------*/
  final Rx<ArtiestDashboardModel> _artiestDashboardModel =
      ArtiestDashboardModel().obs;
  ArtiestDashboardModel get getArtiestDashboardModel =>
      _artiestDashboardModel.value;
  set setArtiestDashboardModel(val) => _artiestDashboardModel.value = val;

  /*---------------------- Over all  Review Get ---------------*/
  final Rx<OverallReviewListModel> _overallStylistReviewListModel =
      OverallReviewListModel().obs;
  OverallReviewListModel get getOverallStylistReviewListModel =>
      _overallStylistReviewListModel.value;
  set setOverallStylistReviewListModel(val) =>
      _overallStylistReviewListModel.value = val;

/*----------------------  Store  Artist Portfolio ---------------*/
  final Rx<ArtistPortfolioModel> _artistPortfolioModel =
      ArtistPortfolioModel().obs;
  ArtistPortfolioModel get getArtistPortfolioModel =>
      _artistPortfolioModel.value;
  set setArtistPortfolioModel(val) => _artistPortfolioModel.value = val;

  final RxBool _portfolioUploadBusy = false.obs;
  bool get portfolioUploadBusy => _portfolioUploadBusy.value;

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
      
      // Update button visibility based on appointment details
      _updateTakePicturesButtonVisibility();
    } catch (e) {
      showError(e);
      debugPrint("Stylist Appointment ===> ${e.toString()}");
    } finally {
      _showProgress.value = false;
    }
  }

  void _updateTakePicturesButtonVisibility() {
    final data = _appointmentsDetailsModel.value.data;
    
    // Don't show for completed bookings
    if (data?.orderStatus?.toLowerCase() == 'completed') {
      _shouldShowTakePicturesButton.value = false;
      return;
    }
    
    // Check if portfolio upload is allowed
    final allowPortfolioUpload = data?.allowPortfolioUpload ?? false;
    
    // Update reactive variable
    _shouldShowTakePicturesButton.value = allowPortfolioUpload;
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
  doGetServedBooking({required String distribution}) async {
    try {
      _showProgress.value = true;
      _completeAppointmentsListModel.value =
          await StylistAPI.servedBookingSection(distribution: distribution);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------- do Upload Image ------------------*/
  Future<void> doUploadImage({
    required String appointmentId,
    required List<String> multiplePath,
    required List<String> multiplePathVideo,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      String result = await StylistAPI.uploadImage(
          appointmentId: appointmentId,
          multiplePath: multiplePath,
          multipleVideo: multiplePathVideo);
      if (result != "") {
        callback.call();
      }
    } catch (e) {
      showError(e);
      print("Error Data Show new ${e.toString()}");
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------- Do Blog Crate ----------------*/
  doCreateBlog({
    required String title,
    required String externalLink,
    required String body,
    required String description,
    required File image,
    required File video,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await StylistAPI.addArtiestBlog(
          title: title,
          externalLink: externalLink,
          body: body,
          description: description,
          image: image,
          video: video);
      if (result) {
        callback.call();
      }
    } catch (e) {
      print(e.toString());
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

  /// `PUT /artist/blog/:id` — only [description] and/or new [image] / [video] files.
  Future<void> doUpdateArtistBlog({
    required String blogId,
    required String description,
    File? image,
    File? video,
    VoidCallback? onSuccess,
  }) async {
    try {
      final descTrim = description.trim();
      final ok = await StylistAPI.updateArtistBlog(
        blogId: blogId,
        description: descTrim,
        image: image,
        video: video,
      );
      if (ok) {
        await doGetBlog();
        onSuccess?.call();
      }
    } catch (e) {
      showError(e);
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

  /*------------------ get Artiest Dashboard Model -----------------*/
  doGetArtiestDashBoard({required String distribution}) async {
    try {
      _showProgress.value = true;
      _artiestDashboardModel.value =
          await StylistAPI.getStylistDashBoard(distribution: distribution);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*---------------------  Do get ArtistPortfolio -------------------*/
  doGetArtistPortfolio({bool showProgress = true}) async {
    try {
      if (showProgress) _showProgress.value = true;
      _artistPortfolioModel.value = await StylistAPI.getArtiestPortfolio();
    } catch (e) {
      showError(e);
    } finally {
      if (showProgress) _showProgress.value = false;
    }
  }

  static const int portfolioMaxItems = 3;

  /*--------------------  Add / fill portfolio (API create or PATCH slot) ------*/
  Future<void> doUploadPortfolioMedia({
    required File file,
    required bool isImage,
    required VoidCallback callback,
  }) async {
    final list = _artistPortfolioModel.value.data?.portfolio ?? [];
    if (list.length >= portfolioMaxItems) {
      showError('You can add up to $portfolioMaxItems portfolio items.');
      return;
    }

    try {
      _portfolioUploadBusy.value = true;
      await StylistAPI.uploadSamplePortfolio(
        imagePaths: isImage ? [file.path] : const [],
        videoPaths: isImage ? const [] : [file.path],
      );

      await doGetArtistPortfolio(showProgress: false);
      callback();
    } catch (e) {
      showError(e);
    } finally {
      _portfolioUploadBusy.value = false;
    }
  }

  /*--------------------  Update PortFolio  For Stylist  --------------*/
  doUpdatePostFolio({
    required String portfolioId,
    required bool isImage,
    required File file,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await StylistAPI.updatePortFolio(
        portfolioId: portfolioId,
        image: file,
        video: file,
        isImage: isImage,
      );

      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*---------------------  Update TimeSlot For Stylist -------------*/
  doUpdateBookingTimeSlot({
    required String appointmentId,
    required Map changeMinutes,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = false;

      bool result = await StylistAPI.updateBookingTimeSlat(
          appointmentId: appointmentId, changeMinutes: changeMinutes);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose of reactive variables
    _shouldShowTakePicturesButton.close();
    super.onClose();
  }
}
