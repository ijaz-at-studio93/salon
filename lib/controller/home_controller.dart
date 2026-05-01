import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/home_api.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/model/availability/salon_avibility_model.dart';
import 'package:salon/model/bank_account/salon_bank_account.dart';
import 'package:salon/model/salon_category/salon_category_model.dart';
import 'package:salon/model/salon_dash_board/salon_dash_board_model.dart';
import 'package:salon/model/salon_document_model/eligibility_model.dart';
import 'package:salon/model/salon_document_model/salon_document_get_model.dart';
import 'package:salon/model/salon_review_model/salon_overall_review_model.dart';
import 'package:salon/model/salon_review_model/salon_review_by_artiest_model.dart';
import 'package:salon/model/service_model/appointment_details_model.dart';
import 'package:salon/model/service_model/category_list_model.dart';
import 'package:salon/model/service_model/pending_appointments_list_model.dart';
import 'package:salon/model/service_model/product_list_data_model.dart';
import 'package:salon/model/service_model/salon_service_list_model.dart';
import 'package:salon/model/service_model/service_preview_model.dart';
import 'package:salon/model/service_model/setting_salon_service_list_model.dart';
import 'package:salon/model/stylist/artiest_details_model.dart';
import 'package:salon/model/stylist/artiest_list_model.dart';
import 'package:salon/model/stylist/all_salon_staff_model.dart';

import '../model/stylist/allow_portfolio_upload_model.dart';
import '../model/translation/salon_transaction_history_model.dart';
import '../model/translation/translation_history_model.dart';
import '../model/service_model/rejection_reason_model.dart';

class HomeController extends GetxController {
  /*---------------  Show Progressbar --------------*/
  final Rx<bool> _showProgress = false.obs;
  bool get showProgress => _showProgress.value;
  set setShowProgress(val) => _showProgress.value = val;

  final Rx<bool> _showProgressCategory = false.obs;
  bool get showProgressCategory => _showProgressCategory.value;
  set setShowProgressCategory(val) => _showProgressCategory.value = val;

  final Rx<bool> _showContentProgress = false.obs;
  bool get showContentProgress => _showContentProgress.value;

  /*-----------------  Eligibility Store  ---------------*/
  final Rx<EligibilityModel> _eligibility = EligibilityModel().obs;
  EligibilityModel get getEligibilityModel => _eligibility.value;
  set setEligibilityModel(val) => _eligibility.value = val;

  /*------------------- Store Service Category List -------------*/
  final Rx<CategoryListModel> _categoryListModel = CategoryListModel().obs;
  CategoryListModel get getCategoryModel => _categoryListModel.value;
  set setCategoryModelData(val) => _categoryListModel.value = val;

  int selectCategoryCount = 0;

  /*---------------  Store Product List Data ----------------*/
  final Rx<ProductListModel> _productListModel = ProductListModel().obs;
  ProductListModel get getProductListModel => _productListModel.value;
  set setProductListModel(val) => _productListModel.value = val;

  /*-----------------  Service Review Data Store --------------*/

  final Rx<ServicePreviewModel> _serviceReviewModel = ServicePreviewModel().obs;
  ServicePreviewModel get getServiceReviewModel => _serviceReviewModel.value;
  set setServiceReviewModel(val) => _serviceReviewModel.value = val;

  /*-------------------- Salon Service List Data Get --------------*/
  final Rx<SalonServiceListModel> _salonServiceList =
      SalonServiceListModel().obs;
  SalonServiceListModel get getSalonServiceList => _salonServiceList.value;
  set setSalonServiceList(val) => _salonServiceList.value = val;

/*------------------------ SettingSalonServiceListModel ----------------*/
  final Rx<SettingSalonServiceListModel> _settingSalonServiceListModel =
      SettingSalonServiceListModel().obs;
  SettingSalonServiceListModel get getSettingSalonServiceListModel =>
      _settingSalonServiceListModel.value;
  set setSettingSalonServiceListModel(val) =>
      _settingSalonServiceListModel.value = val;

  /*-------------------  Salon UpComing -------------------*/
  final Rx<PendingAppointmentsListModel> _salonUpcomingList =
      PendingAppointmentsListModel().obs;
  PendingAppointmentsListModel get getSalonUpcomingList =>
      _salonUpcomingList.value;
  set setSalonUpcomingList(val) => _salonUpcomingList.value = val;

  /*-------------------  Salon Served Appointments --------------*/
  final Rx<PendingAppointmentsListModel> _salonServedList =
      PendingAppointmentsListModel().obs;
  PendingAppointmentsListModel get getSalonServedList => _salonServedList.value;
  set setSalonServedList(val) => _salonServedList.value = val;

  /*------------------------- Complete Booking For QrCode ---------------------*/
  final Rx<AllowPortfolioUploadModel> _allowPortfolioUploadModel =
      AllowPortfolioUploadModel().obs;
  AllowPortfolioUploadModel get getAllowPortfolioUploadModel =>
      _allowPortfolioUploadModel.value;
  set setAllowPortfolioUploadModel(val) =>
      _allowPortfolioUploadModel.value = val;

  final qrScanned = <String, bool>{}.obs; // appointmentId -> scanned?
  final qrToken = <String, String>{}.obs; // appointmentId -> token

  void setQrScan(String appointmentId, String token) {
    qrScanned[appointmentId] = true;
    qrToken[appointmentId] = token;
    qrScanned.refresh();
  }

  void clearQrScan(String appointmentId) {
    qrScanned.remove(appointmentId);
    qrToken.remove(appointmentId);
    qrScanned.refresh();
  }

  /*-------------------- do Upload Image ------------------*/
  doUploadImage(
      {required String appointmentId,
      required List<String> multiplePath,
      required List<String> multiplePathVideo,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      String result = await HomeAPI.uploadImage(
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

  /*------------------- Salon Cancel Appointment -----------------*/
  final Rx<PendingAppointmentsListModel> _salonCancelServedList =
      PendingAppointmentsListModel().obs;
  PendingAppointmentsListModel get getSalonCancelServedList =>
      _salonCancelServedList.value;
  set setSalonCancelServedList(val) => _salonCancelServedList.value = val;

  /*-------------------  Appointment Details  -------------------*/
  final Rx<AppointmentDetailsModel> _appointmentDetailsModel =
      AppointmentDetailsModel().obs;
  AppointmentDetailsModel get getAppointmentDetailsModel =>
      _appointmentDetailsModel.value;
  set setAppointmentDetailsModel(val) => _appointmentDetailsModel.value = val;

  /*---------------------  Salon Artist List  -----------------------------*/
  final Rx<SalonArtistListModel> _salonArtistListModel =
      SalonArtistListModel().obs;
  SalonArtistListModel get getSalonArtistListModel =>
      _salonArtistListModel.value;
  set setSalonArtistListModel(val) => _salonArtistListModel.value = val;

  /*---------------------  All Salon Staff List  -----------------------------*/
  final Rx<AllSalonStaffModel> _allSalonStaffModel = AllSalonStaffModel().obs;
  AllSalonStaffModel get getAllSalonStaffModel => _allSalonStaffModel.value;
  set setAllSalonStaffModel(val) => _allSalonStaffModel.value = val;

  /*--------------------- Over All Rating -----------------*/
  final Rx<OverallReviewListModel> _overallReviewListModel =
      OverallReviewListModel().obs;
  OverallReviewListModel get getOverallReviewListModel =>
      _overallReviewListModel.value;
  set setOverallReviewListModel(val) => _overallReviewListModel.value = val;

  /*----------------------------- Artiest  Review  ------------------- */
  final Rx<SalonReviewByArtiestModel> _salonReviewByArtiestModel =
      SalonReviewByArtiestModel().obs;
  SalonReviewByArtiestModel get getSalonReviewByArtiestModel =>
      _salonReviewByArtiestModel.value;
  set setSalonReviewByArtiestModel(val) =>
      _salonReviewByArtiestModel.value = val;

  /*-------------------------- ArtiestAvailabilityGetModel  -----------------*/
  final Rx<ArtiestAvailabilityGetModel> _artiestAvailabilityGetModel =
      ArtiestAvailabilityGetModel().obs;
  ArtiestAvailabilityGetModel get getArtiestAvailabilityGetModel =>
      _artiestAvailabilityGetModel.value;
  set setArtiestAvailabilityGetModel(val) =>
      _artiestAvailabilityGetModel.value = val;

  /*-------------------- SalonAvailability -------------*/
  final Rx<SalonAvailability> _salonAvailability = SalonAvailability().obs;
  SalonAvailability get getSalonAvailability => _salonAvailability.value;
  set setSalonAvailability(val) => _salonAvailability.value = val;

  /*---------------------  BlogDataGetModel -------------------*/
  final Rx<BlogDataGetModel> _salonBlogDataGetModel = BlogDataGetModel().obs;
  BlogDataGetModel get getBlogDataGetModel => _salonBlogDataGetModel.value;
  set setBlogDataGetModel(val) => _salonBlogDataGetModel.value = val;

  /*-------------------------- Upload Document -------------------*/
  final Rx<SalonDocumentGetModel> _salonDocumentGetModel =
      SalonDocumentGetModel().obs;
  SalonDocumentGetModel get getSalonDocumentGetModel =>
      _salonDocumentGetModel.value;
  set setSalonDocumentGetModel(val) => _salonDocumentGetModel.value = val;

  /*------------  Get Artiest Details -----------*/
  final Rx<ArtiestDetailsModel> _artiestDetailsModel =
      ArtiestDetailsModel().obs;
  ArtiestDetailsModel get getArtiestDetailsModel => _artiestDetailsModel.value;
  set setArtiestDetailsModel(val) => _artiestDetailsModel.value = val;

  /*----------------- Get Salon DashBoard --------------*/
  final Rx<SalonDashboardModel> _salonDashboardModel =
      SalonDashboardModel().obs;
  SalonDashboardModel get getSalonDashboardModel => _salonDashboardModel.value;
  set setSalonDashboardModel(val) => _salonDashboardModel.value = val;

  /*----------------------  TransactionsHistoryModel --------------*/
  final Rx<TransactionsHistoryModel> _transactionsHistoryModel =
      TransactionsHistoryModel().obs;
  TransactionsHistoryModel get getTransactionsHistoryModel =>
      _transactionsHistoryModel.value;
  set setTransactionsHistoryModel(val) => _transactionsHistoryModel.value = val;

  /*----------------------  SalonTransactionsHistoryModel --------------*/
  final Rx<SalonTransactionsHistoryModel> _salonTransactionsHistoryModel =
      SalonTransactionsHistoryModel().obs;
  SalonTransactionsHistoryModel get getSalonTransactionsHistoryModel =>
      _salonTransactionsHistoryModel.value;
  set setSalonTransactionsHistoryModel(val) => _salonTransactionsHistoryModel.value = val;

  /*------------------- TransactionsHistoryUnsettledModel  ---------------------*/
  final Rx<TransactionsHistoryModel> _transactionsHistoryUnsettledModel =
      TransactionsHistoryModel().obs;
  TransactionsHistoryModel get getTransactionsUnsettleHistoryModel =>
      _transactionsHistoryUnsettledModel.value;
  set setTransactionsUnsettleHistoryModel(val) =>
      _transactionsHistoryUnsettledModel.value = val;

  /*============================= Salon Category =======================*/
  final Rx<SalonCategoryListModel> _salonCategoryListModel =
      SalonCategoryListModel().obs;
  SalonCategoryListModel get getSalonCategoryListModel =>
      _salonCategoryListModel.value;
  set setSalonCategoryListModel(val) => _salonCategoryListModel.value = val;

  /*-------------------- Get  bank List ----------------------*/
/*  final RxList<ListAllBankModel> _bankModelList = <ListAllBankModel>[].obs;
  List<ListAllBankModel> get bankModelList => _bankModelList;*/

  /*-------------------  get  Account Data list ------------*/
  final Rx<SalonBankAccountList> _salonBankAccountList =
      SalonBankAccountList().obs;
  SalonBankAccountList get getSalonBankAccountList =>
      _salonBankAccountList.value;
  set setSalonBankAccountList(val) => _salonBankAccountList.value = val;

  /*---------------  Category Id and Product Id List Data Store ----------------*/
  final RxList categoryId = [].obs;
  final RxList productId = [].obs;

  /*-------------------- service Id & Gender ------------------*/
  final RxList serviceId = [].obs;
  final RxList gender = [].obs;

  /*----------------  Salon Service Id -------------------*/
  final Rx<String> salonServiceId = "".obs;

  /*-----------------  Status Change  ---------------*/
  final Rx<bool> _statusChange = false.obs;
  bool get getStatus => _statusChange.value;
  set setStatus(val) => _statusChange.value = val;

  /*-----------------------  eligibility check ---------------*/
  doCheckEligibility({required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      _eligibility.value = await HomeAPI.checkEligibility();
      if (_eligibility.value.data?.isApproved ?? false) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*---------------------  doGet category List  data ---------------*/
  doGetCategoryListData() async {
    try {
      _showProgressCategory.value = true;
      _categoryListModel.value = await HomeAPI.getCategoryList();
    } catch (e) {
      showError(e);
    } finally {
      _showProgressCategory.value = false;
    }
  }

  /*------------------------ doGet ProductListData    -----------------------------------*/
  doGetProductListData() async {
    try {
      _showProgress.value = true;
      _productListModel.value = await HomeAPI.getProductList();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------- delete product ---------------------*/
  doDeleteProduct(
      {required VoidCallback callback, required String productId}) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.deleteProduct(productId: productId);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------- Delete Stylist ----------*/
  doDeleteArtiest(
      {required VoidCallback callback, required String artistId}) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.deleteStylist(artistId: artistId);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------  Add  Product -----------------------*/
  doAddProduct({
    String? categoryId,
    String? salonCategory,
    required String name,
    required String description,
    required String price,
    required File? image,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.productAdd(
          categoryId: categoryId,
          salonCategory: salonCategory,
          name: name,
          description: description,
          price: price,
          image: image);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------  Update Product --------------*/
  doUpdateProduct({
    required String productId,
    required String name,
    required String description,
    required File? image,
    //String? serviceCategoryId,
    String? salonCategory,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.updateProduct(
          productId: productId,
          name: name,
          description: description,
          image: image,
          //serviceCategoryId: serviceCategoryId
          salonCategory: salonCategory);

      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------------ get Service Review --------------*/
  doGetServiceReview({required String salonServiceId}) async {
    try {
      _showProgress.value = true;
      _serviceReviewModel.value =
          await HomeAPI.servicePreView(salonServiceId: salonServiceId);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------  Add Service -----------------------*/
  doAddService({
    required String name,
    required String description,
    required String price,
    required String duration,
    required String gender,
    required List<String> categoryID,
    required List<String> productId,
    required File? image,
    required bool isHomeService,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      salonServiceId.value = await HomeAPI.addService(
          name: name,
          description: description,
          price: price,
          duration: duration,
          gender: gender,
          categoryID: categoryID,
          productId: productId,
          image: image,
          isHomeService: isHomeService);
      if (salonServiceId.value.isNotEmpty) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------  Update service ----------------*/
  doUpdateService({
    required String serviceId,
    required String name,
    required String description,
    required String price,
    required String duration,
    required String gender,
    required List<String> categoryID,
    required List<String> productId,
    required File? image,
    required bool isHomeService,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.updateService(
          serviceId: serviceId,
          name: name,
          description: description,
          price: price,
          duration: duration,
          gender: gender,
          categoryID: categoryID,
          productId: productId,
          image: image,
          isHomeService: isHomeService);

      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
      print(e.toString());
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------- service status --------------*/
  doUpdateStatus(
      {required String salonServiceId, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      _statusChange.value =
          await HomeAPI.salonServicePathCall(salonServiceId: salonServiceId);
      if (_statusChange.value) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*---------------------- salon service list ---------------------- */
  doGetSalonServiceList() async {
    try {
      _showProgress.value = true;
      _salonServiceList.value = await HomeAPI.salonServiceListGet();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------------ salon artiest add -----------*/
  doAddArtiest({
    required String name,
    required String mobile,
    required String countryCode,
    required String experience,
    required String whatsapp,
    required String homeService,
    required String password,
    required String gender,
    required File image,
    required List<File> portfolioFiles,
    required List<String> storeId,
    required List<String> genderDataList,
    required String sId,
    required String profession,
    required List<String> languagesKnown,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.salonArtist(
          name: name,
          mobile: mobile,
          countryCode: countryCode,
          experience: experience,
          whatsapp: whatsapp,
          homeService: homeService,
          password: password,
          gender: gender,
          image: image,
          portfolioFiles: portfolioFiles,
          storeId: storeId,
          genderDataList: genderDataList,
          sId: sId,
          profession: profession,
          languagesKnown: languagesKnown);
      if (result) {
        callback.call();
      }
    } catch (e) {
      print(e);
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------- Update stylist Basic Info -----------------*/
  doUpdateStylistBasicInfo({
    required String artistId,
    required String name,
    required String mobile,
    required String countryCode,
    required String experience,
    required String whatsapp,
    required String homeService,
    required String gender,
    required File image,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.updateBasicInfoStylist(
          artistId: artistId,
          name: name,
          mobile: mobile,
          countryCode: countryCode,
          experience: experience,
          whatsapp: whatsapp,
          homeService: homeService,
          gender: gender,
          image: image);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------------- Update Stylist Service -------------------*/
  doUpdateStylistService({
    required String artistId,
    required List<String> storeId,
    required List<String> genderDataList,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.stylistUpdateService(
          artistId: artistId, genderDataList: genderDataList, storeId: storeId);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------- Upcoming Booking  Data ----------------*/
  String _lastUpcomingDistribution = 'today';

  static const Set<String> _pendingDistributionValues = {
    'today',
    'tomorrow',
    'yesterday',
    'this_week',
    'this_month',
    'this_year',
    'all_time',
  };

  doUpcomingData({String? distribution}) async {
    try {
      _showProgress.value = true;
      final requested = distribution ?? _lastUpcomingDistribution;
      final d = _pendingDistributionValues.contains(requested)
          ? requested
          : 'today';
      _lastUpcomingDistribution = d;
      _salonUpcomingList.value =
          await HomeAPI.getPendingAppointments(distribution: d);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------------ Rejection Reasons  ------------------------*/
  final Rx<RejectionReasonModel?> _rejectionReasons =
      Rx<RejectionReasonModel?>(null);
  List<RejectionReason> get getRejectionReasonsList =>
      _rejectionReasons.value?.data ?? [];

  doGetRejectionReasons() async {
    try {
      _rejectionReasons.value = await HomeAPI.getRejectionReasons();
    } catch (e) {
      showError(e);
    }
  }

  /*------------------------ Approve Booking  ------------------------*/
  doBookingApprove({
    required String appointmentId,
    required String status,
    required VoidCallback callback,
    List<String>? stylistIds,
    String? startsAt,
    String? endsAt,
    String? rejectionReasonId,
    String? rejectionRemark,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.approveBooking(
        appointmentId: appointmentId,
        status: status,
        stylistIds: stylistIds,
        startsAt: startsAt,
        endsAt: endsAt,
        rejectionReasonId: rejectionReasonId,
        rejectionRemark: rejectionRemark,
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

  /*------------------------- Qr Code To Booking Page -------------------*/
  doScanQrcode({
    required String appointmentId,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      _allowPortfolioUploadModel.value =
          await HomeAPI.qrcodeScan(appointmentId: appointmentId);

      final startsAt =
          _allowPortfolioUploadModel.value.data?.appointment?.startsAt;
      if ((startsAt ?? '').isNotEmpty) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------------  Get Cancel Booking Data --------------*/
  doCancelData({
    String? distribution,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      _showProgress.value = true;
      _salonCancelServedList.value = await HomeAPI.getCancelAppointments(
        distribution: distribution,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------- Complete Booking  Data ----------------*/
  doCompleteBookingData({
    String? distribution,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      _showProgress.value = true;
      _salonServedList.value = await HomeAPI.getServedAppointments(
        distribution: distribution,
        fromDate: fromDate,
        toDate: toDate,
      );
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------  Appointment Details Model ---------------------*/
  doGetAppointmentDetailsModel({required String appointmentId}) async {
    try {
      _showProgress.value = true;
      _appointmentDetailsModel.value =
          await HomeAPI.appointmentDetails(appointmentId: appointmentId);
    } catch (e) {
      showError(e);
      debugPrint(e.toString());
    } finally {
      _showProgress.value = false;
    }
  }

/*-----------------  Salon Artiest  List Data Get ----------------*/
  doSalonArtistList() async {
    try {
      _showProgress.value = true;
      _salonArtistListModel.value = await HomeAPI.getSalonArtiestListData();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------  All Salon Staff List ----------------*/
  Future<AllSalonStaffModel> doGetAllSalonStaffList() async {
    try {
      _allSalonStaffModel.value = await HomeAPI.getAllSalonStaffList();
    } catch (_) {}
    return _allSalonStaffModel.value;
  }

  /*-----------------  Lookup Artist by SId ----------------*/
  Future<StaffData?> doLookupArtistBySId({required String sId}) async {
    return await HomeAPI.lookupArtistBySId(sId: sId);
  }

  /*-----------------  Add Existing Artist by SId ----------------*/
  doAddExistingArtistBySId({
    required String sId,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      final result = await HomeAPI.addExistingArtistBySId(sId: sId);
      if (result) {
        callback();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------  Get Over All Review ------------------*/
  doGetOverallReview() async {
    try {
      _showProgress.value = true;
      _overallReviewListModel.value = await HomeAPI.getOverAllReview();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------  Get Artiest Review ----------*/
  doGetArtiestReview() async {
    try {
      _showProgress.value = true;
      _salonReviewByArtiestModel.value =
          await HomeAPI.getSalonReviewByArtiest();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------- Get Artiest Availability  -------------------*/
  doGetArtiestAvailability({required String artistId}) async {
    try {
      _showProgress.value = true;
      _artiestAvailabilityGetModel.value =
          await HomeAPI.getArtiestAvailability(artistId: artistId);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------- Get Artiest Availability  -------------------*/
  doBlockArtiestAvailability(
      {required String artistId,
      required DateTime? start,
      required DateTime? end}) async {
    try {
      _showProgress.value = true;
      _artiestAvailabilityGetModel.value = await HomeAPI.blockSlotForArtist(
          artistId: artistId, start: start, end: end);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------  Update Artiest Availability  -----------------*/
  doUpdateArtiestAvailability(
      {required Map availability,
      required String artistId,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.updateArtiestAvailability(
          availability: availability, artistId: artistId);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------- SalonAvailability ----------------*/
  doGetSalonAvailability() async {
    try {
      _showProgress.value = true;
      _salonAvailability.value = await HomeAPI.getSalonAvailability();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------------- Update SalonAvailability -------------------------- */
  doUpdateSalonAvailability(
      {required Map availability, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result =
          await HomeAPI.updateSalonAvailability(availability: availability);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------  Get Salon Document -------------------*/
  doGetSalonDocument() async {
    try {
      _showProgress.value = true;
      _salonDocumentGetModel.value = await HomeAPI.getSalonDocument();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------  Salon Upload Document ------------------*/
  doUploadDocument(
      {required String documentId,
      required File image,
      required VoidCallback callback}) async {
    try {
      _showProgressCategory.value = true;
      bool result =
          await HomeAPI.documentSubmit(documentId: documentId, image: image);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgressCategory.value = false;
    }
  }

  /*---------------  Salon Blog Data Get ------------ */
  doGetSalonBlogData({required String url}) async {
    try {
      _showProgress.value = true;
      _salonBlogDataGetModel.value = await HomeAPI.getSalonBlogList(url: url);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*---------------  Salon Content Get  ------------ */
  doGetSalonContentList() async {
    try {
      _showContentProgress.value = true;
      _salonBlogDataGetModel.value = await HomeAPI.getSalonContentList();
    } catch (e) {
      showError(e);
    } finally {
      _showContentProgress.value = false;
    }
  }

  /*---------------  Salon Content Create  ------------ */
  doCreateSalonContent({
    required String description,
    File? file,
    bool isVideo = false,
    required VoidCallback callback,
  }) async {
    try {
      _showContentProgress.value = true;
      bool result = await HomeAPI.createSalonContent(
        description: description,
        content: file,
      );
      if (result) callback.call();
    } catch (e) {
      showError(e);
    } finally {
      _showContentProgress.value = false;
    }
  }

  /*---------------  Salon Content Update  ------------ */
  doUpdateSalonContent({
    required String contentId,
    String? description,
    File? file,
    bool isVideo = false,
    required VoidCallback callback,
  }) async {
    try {
      _showContentProgress.value = true;
      bool result = await HomeAPI.updateSalonContent(
        contentId: contentId,
        description: description,
        file: file,
        isVideo: isVideo,
      );
      if (result) callback.call();
    } catch (e) {
      showError(e);
    } finally {
      _showContentProgress.value = false;
    }
  }

  /*---------------  Salon Content Delete  ------------ */
  doDeleteSalonContent({
    required String contentId,
    required VoidCallback callback,
  }) async {
    try {
      _showContentProgress.value = true;
      bool result = await HomeAPI.deleteSalonContent(contentId: contentId);
      if (result) callback.call();
    } catch (e) {
      showError(e);
    } finally {
      _showContentProgress.value = false;
    }
  }

  /*---------------- Get Artiest Details --------------*/
  doGetArtiestDetails(
      {required String artistId, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      _artiestDetailsModel.value =
          await HomeAPI.getSalonArtiest(artistId: artistId);
      if (_artiestDetailsModel.value.data?.id?.isNotEmpty ?? false) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------  Get Salon DashBoard -----------------*/
  doGetSalonDashBoard({required String distribution}) async {
    try {
      _showProgress.value = true;
      _salonDashboardModel.value =
          await HomeAPI.getSalonDashBoard(distribution: distribution);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------  Salon wallet recharge request -----------------*/
  // doRequestSalonRecharge() async {
  //   try {
  //     _showProgress.value = true;
  //     final msg = await HomeAPI.requestSalonRecharge();
  //     if (msg != null && msg.isNotEmpty) {
  //       await showMessage(msg);
  //     }
  //     // _salonDashboardModel.value =
  //     //     await HomeAPI.getSalonDashBoard(distribution: distribution);
  //   } catch (e) {
  //     showError(e);
  //   } finally {
  //     _showProgress.value = false;
  //   }
  // }

  doRequestSalonRecharge() async {
    try {
      //_showProgress.value = true;
      final msg = await HomeAPI.requestSalonRecharge();
      return msg;
    } catch (e) {
      showError(e);
      return null;
    }
    // } finally {
    //   _showProgress.value = false;
    // }
  }

  /* -------------------- Transaction History -------------------- */
  doGetTransactionHistory({required String distribution}) async {
    try {
      _showProgress.value = true;
      _transactionsHistoryModel.value =
          await HomeAPI.getTransactionHistory(distribution: distribution);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /* -------------------- Salon Transaction History -------------------- */
  doGetSalonWalletTransactions({required String distribution}) async {
    try {
      _showProgress.value = true;
      _salonTransactionsHistoryModel.value =
      await HomeAPI.getSalonWalletTransactionHistory(distribution: distribution);
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------------- Transaction Unsettled ------------------ */
  doGetTransactionUnsettledHistory({required String distribution}) async {
    try {
      _showProgress.value = true;
      _transactionsHistoryUnsettledModel.value =
          await HomeAPI.getTransactionUnsettledHistory(
              distribution: distribution);
    } catch (e) {
      showError(e);
      print(e.toString());
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------------- My Details  Salon Service by  Category  ----------------*/
  doGetSalonServiceCategory() async {
    try {
      _showProgress.value = true;
      _settingSalonServiceListModel.value =
          await HomeAPI.getSalonServiceByCategory();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*============================  Salon Category ===========================*/
  doGetSalonCategory() async {
    try {
      _showProgress.value = true;
      _salonCategoryListModel.value = await HomeAPI.getSalonCategory();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*--------------- Add Category -------------------------*/
  doAddSalonCategory(
      {required String name,
      required String description,
      required String serviceableGender,
      required String profession,
      required File? maleImage,
      required File? femaleImage,
      required VoidCallback callback}) async {
    try {
      print('profession is *****************$profession');
      _showProgress.value = true;
      bool result = await HomeAPI.addSalonCategory(
          name: name,
          description: description,
          serviceableGender: serviceableGender,
          profession: profession,
          maleImage: maleImage,
          femaleImage: femaleImage);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------------- Delete Salon Category --------------------------*/
  doDeleteSalonCategory(
      {required String salonCategoryId, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result =
          await HomeAPI.deleteSalonCategory(salonCategoryId: salonCategoryId);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------------  do Update Salon  Category ------------------------*/
  doUpdateCategory(
      {required String name,
      required String description,
      required String serviceableGender,
      required String salonCategoryId,
      required File? maleImage,
      required File? femaleImage,
      required VoidCallback callback}) async {
    try {
      _showProgress.value = true;

      bool result = await HomeAPI.salonUpdateCategory(
          name: name,
          description: description,
          serviceableGender: serviceableGender,
          salonCategoryId: salonCategoryId,
          maleImage: maleImage,
          femaleImage: femaleImage);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------- bankModelList ---------------*/
  /* doGetBankList() async {
    try {
      _showProgress.value = true;
      _bankModelList.value = await HomeAPI.getListBankListData();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }
*/
  /*-------------------- Get Bank Account Details --------------*/
  doGetBankAccountDetails() async {
    try {
      _showProgress.value = true;
      _salonBankAccountList.value = await HomeAPI.getSalonBankAccount();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-------------------  do Add Salon Account ----------------*/
  doAddSalonBankAccount(
      {required Map account, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.salonAccountCreate(account: account);
      if (result) {
        callback.call();
      }
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*------------------ Delete Bank account ----------------*/
  doDeleteBankAccount(
      {required String accountId, required VoidCallback callback}) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.deleteBankAccount(accountId: accountId);
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
