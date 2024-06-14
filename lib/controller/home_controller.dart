import 'dart:io';
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/home_api.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/model/availability/salon_avibility_model.dart';
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
import 'package:salon/model/stylist/artiest_details_model.dart';
import 'package:salon/model/stylist/artiest_list_model.dart';

class HomeController extends GetxController {
  /*---------------  Show Progressbar --------------*/
  final Rx<bool> _showProgress = false.obs;
  bool get showProgress => _showProgress.value;
  set setShowProgress(val) => _showProgress.value = val;

  final Rx<bool> _showProgressCategory = false.obs;
  bool get showProgressCategory => _showProgressCategory.value;
  set setShowProgressCategory(val) => _showProgressCategory.value = val;

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
  doCheckEligibility() async {
    try {
      _showProgress.value = true;
      _eligibility.value = await HomeAPI.checkEligibility();
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

  /*--------------------  Add  Product -----------------------*/
  doAddProduct({
    required String categoryId,
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
    required String price,
    required File? image,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool  result =  await  HomeAPI.updateProduct(productId: productId, name: name, description: description, price: price, image: image);

      if(result){
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
    required String email,
    required String experience,
    required String address,
    required String whatsapp,
    required String panCard,
    required String homeService,
    required String password,
    required String gender,
    required String dob,
    required File image,
    required List<String> storeId,
    required List<String> genderDataList,
    required VoidCallback callback,
  }) async {
    try {
      _showProgress.value = true;
      bool result = await HomeAPI.salonArtist(
          name: name,
          mobile: mobile,
          countryCode: countryCode,
          email: email,
          experience: experience,
          address: address,
          whatsapp: whatsapp,
          panCard: panCard,
          homeService: homeService,
          password: password,
          gender: gender,
          dob: dob,
          image: image,
          storeId: storeId,
          genderDataList: genderDataList);
      if (result) {
        callback.call();
      }
    } catch (e) {
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
    required String email,
    required String experience,
    required String address,
    required String whatsapp,
    required String panCard,
    required String homeService,
    required String gender,
    required String dob,
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
          email: email,
          experience: experience,
          address: address,
          whatsapp: whatsapp,
          panCard: panCard,
          homeService: homeService,
          gender: gender,
          dob: dob,
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
  doUpcomingData() async {
    try {
      _showProgress.value = true;
      _salonUpcomingList.value = await HomeAPI.getPendingAppointments();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*-----------------------  Get Cancel Booking Data --------------*/
  doCancelData() async {
    try {
      _showProgress.value = true;
      _salonCancelServedList.value = await HomeAPI.getCancelAppointments();
    } catch (e) {
      showError(e);
    } finally {
      _showProgress.value = false;
    }
  }

  /*----------------- Complete Booking  Data ----------------*/
  doCompleteBookingData() async {
    try {
      _showProgress.value = true;
      _salonServedList.value = await HomeAPI.getServedAppointments();
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
}
