import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:salon/api/api_end_point.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/model/availability/salon_avibility_model.dart';
import 'package:salon/model/salon_dash_board/salon_dash_board_model.dart';
import 'package:salon/model/salon_document_model/eligibility_model.dart';
import 'package:salon/model/salon_document_model/salon_document_get_model.dart';
import 'package:salon/model/salon_review_model/salon_overall_review_model.dart';
import 'package:salon/model/salon_review_model/salon_review_by_artiest_model.dart';
import 'package:salon/model/service_model/appointment_details_model.dart';
import 'package:salon/model/service_model/category_list_model.dart';
import 'package:salon/model/service_model/pending_appointments_list_model.dart';
import 'package:salon/model/service_model/product_list_data_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:salon/model/service_model/salon_service_list_model.dart';
import 'package:salon/model/service_model/service_preview_model.dart';
import 'package:salon/model/stylist/artiest_details_model.dart';
import 'package:salon/model/stylist/artiest_list_model.dart';

class HomeAPI {
  /*=================== eligibility =====================*/ static Future<
      EligibilityModel> checkEligibility() async {
    final response = await DioClient.client.get(
      APIEndPoint.eligibility,
    );
    if (response.isSuccess) {
      return EligibilityModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*======================  category List ===============*/
  static Future<CategoryListModel> getCategoryList() async {
    final response = await DioClient.client.get(APIEndPoint.serviceCategory);
    if (response.isSuccess) {
      return CategoryListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*====================== ProductList Data =============*/
  static Future<ProductListModel> getProductList() async {
    final response = await DioClient.client.get(APIEndPoint.productList);
    if (response.isSuccess) {
      return ProductListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*===================== Salon Product Add ===============*/
  static Future<bool> productAdd({
    required String categoryId,
    required String name,
    required String description,
    required String price,
    required File? image,
  }) async {
    final formData = FormData.fromMap({
      "serviceCategoryId": categoryId,
      "name": name,
      "describe": description,
      "price": price,
    });

    if (image != null) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }
    final response =
        await DioClient.client.post(APIEndPoint.productAdd, data: formData);

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*=================== Update Product ===============*/
  static Future<bool> updateProduct({
    required String productId,
    required String name,
    required String description,
    required String price,
    required File? image,
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "description": description,
      "price": price,
    });

    if (image != null) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }

    final response = await DioClient.client
        .patch("salon/product/$productId/update", data: formData);

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*=================== Service PreViewpage =============================*/
  static Future<ServicePreviewModel> servicePreView(
      {required String salonServiceId}) async {
    final response =
        await DioClient.client.get("salon/service/$salonServiceId/details");
    if (response.isSuccess) {
      return ServicePreviewModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*=========================== Service Add ========================*/
  static Future<String> addService({
    required String name,
    required String description,
    required String price,
    required String duration,
    required String gender,
    required List<String> categoryID,
    required List<String> productId,
    required File? image,
    required bool isHomeService,
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "description": description,
      "price": price,
      "duration": duration,
      "gender": gender,
      "homeService": isHomeService
    });

    if (categoryID.isNotEmpty) {
      for (int i = 0; i < categoryID.length; i++) {
        formData.fields.add(MapEntry("categoryIds[$i]", categoryID[i]));
      }
    }

    if (productId.isNotEmpty) {
      for (int i = 0; i < productId.length; i++) {
        formData.fields.add(MapEntry("salonProductIds[$i]", productId[i]));
      }
    }

    if (image != null) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }

    final response =
        await DioClient.client.post(APIEndPoint.serviceAdd, data: formData);

    if (response.isSuccess) {
      return response.data['data']['salonService']['id'];
    } else {
      throw response.data;
    }
  }

  /*================= Update Service ===================*/
  static Future<bool> updateService({
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
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "description": description,
      "price": price,
      "duration": duration,
      "gender": gender,
      "homeService": isHomeService
    });

    if (categoryID.isNotEmpty) {
      for (int i = 0; i < categoryID.length; i++) {
        formData.fields.add(MapEntry("categoryIds[$i]", categoryID[i]));
      }
    }

    if (productId.isNotEmpty) {
      for (int i = 0; i < productId.length; i++) {
        formData.fields.add(MapEntry("salonProductIds[$i]", productId[i]));
      }
    }

    if (image != null) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }

    final response = await DioClient.client
        .patch("salon/service/$serviceId/update", data: formData);

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*====================== Salon Patch  Call For Status ==============*/
  static Future<bool> salonServicePathCall(
      {required String salonServiceId}) async {
    final response = await DioClient.client.patch(
        "salon/service/$salonServiceId/status",
        data: {"status": "active"});
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*========================= Salon Service List ==================== */
  static Future<SalonServiceListModel> salonServiceListGet() async {
    final response = await DioClient.client.get(APIEndPoint.getServiceList);
    if (response.isSuccess) {
      return SalonServiceListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*=======================  salon artist add  =======================*/
  static Future<bool> salonArtist({
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
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "mobile": mobile,
      "countryCode": countryCode,
      "email": email,
      "experience": experience,
      "address": address,
      "whatsapp": whatsapp,
      "panCard": panCard,
      "homeService": homeService,
      "password": password,
      "gender": gender,
      "dob": dob
    });

    if (storeId.isNotEmpty) {
      for (int i = 0; i < storeId.length; i++) {
        formData.fields.add(MapEntry("salonService[$i][id]", storeId[i]));
        formData.fields.add(
            MapEntry("salonService[$i][serviceableGender]", genderDataList[i]));
      }
    }

    if (image.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }

    final response = await DioClient.client.post(
      APIEndPoint.salonArtist,
      data: formData,
    );

    if (response.statusCode == 409) {
      showMessage(response.data['message']);
      return false;
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*------------------  Update Stylist Service -----------------*/
  static Future<bool> stylistUpdateService({
    required String artistId,
    required List<String> storeId,
    required List<String> genderDataList,
  }) async {
    final formData = FormData.fromMap({});
    if (storeId.isNotEmpty) {
      for (int i = 0; i < storeId.length; i++) {
        formData.fields.add(MapEntry("salonService[$i][id]", storeId[i]));
        formData.fields.add(
            MapEntry("salonService[$i][serviceableGender]", genderDataList[i]));
      }
    }
    final response = await DioClient.client.patch(
      "salon/artist/$artistId/update",
      data: formData,
    );
    if (response.statusCode == 409) {
      showMessage(response.data['message']);
      return false;
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-------------- Update Basic Info For Stylist ---------------*/
  static Future<bool> updateBasicInfoStylist({
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
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "mobile": mobile,
      "countryCode": countryCode,
      "email": email,
      "experience": experience,
      "address": address,
      "whatsapp": whatsapp,
      "panCard": panCard,
      "homeService": homeService,
      "gender": gender,
      "dob": dob
    });

    if (image.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }

    final response = await DioClient.client.patch(
      "salon/artist/$artistId/update",
      data: formData,
    );

    if (response.statusCode == 409) {
      showMessage(response.data['message']);
      return false;
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-------------- Update Basic Info For Stylist ---------------*/

  /*---------------  Salon Blog Data  -------------*/
  static Future<BlogDataGetModel> getSalonBlogList(
      {required String url}) async {
    final response = await DioClient.client.get(url);
    if (response.isSuccess) {
      return BlogDataGetModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*--------------------------- Get Pending Appointments Model ---------------------*/
  static Future<PendingAppointmentsListModel> getPendingAppointments() async {
    final response =
        await DioClient.client.get("salon/appointments/pending-appointments");
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*----------------------  Get Cancelled Booking  History ----------------------*/
  static Future<PendingAppointmentsListModel> getCancelAppointments(
      {required String distribution}) async {
    final response = await DioClient.client.get(
        "salon/appointments/cancel-appointments",
        queryParameters: {"distribution": distribution});
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*--------------------------  Get Served Appointments --------------------*/
  static Future<PendingAppointmentsListModel> getServedAppointments(
      {required String distribution}) async {
    final response = await DioClient.client.get(
        "salon/appointments/served-appointments",
        queryParameters: {"distribution": distribution});
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*---------------------- Appointment - Details ----------------------------- */
  static Future<AppointmentDetailsModel> appointmentDetails(
      {required String appointmentId}) async {
    final response =
        await DioClient.client.get("salon/appointments/$appointmentId");
    if (response.isSuccess) {
      return AppointmentDetailsModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*------------------- Salon  Artiest L1ist Data ----------------------*/
  static Future<SalonArtistListModel> getSalonArtiestListData() async {
    final response = await DioClient.client.get("salon/artist/list");
    if (response.isSuccess) {
      return SalonArtistListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*--------------  Get OverAll  Review --------------*/
  static Future<OverallReviewListModel> getOverAllReview() async {
    final response = await DioClient.client.get("salon/review/overall/list");
    if (response.isSuccess) {
      return OverallReviewListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-------------------- Salon Review By Artiest ----------*/
  static Future<SalonReviewByArtiestModel> getSalonReviewByArtiest() async {
    final response = await DioClient.client.get("salon/review/by-artist");
    if (response.isSuccess) {
      return SalonReviewByArtiestModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*---------------  Artiest Availability  Get Data ------------- */
  static Future<ArtiestAvailabilityGetModel> getArtiestAvailability(
      {required String artistId}) async {
    final response = await DioClient.client
        .get("salon/availability/artist/$artistId/availability");
    if (response.isSuccess) {
      return ArtiestAvailabilityGetModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*----------------- Artiest Availability data Update -------------- */
  static Future<bool> updateArtiestAvailability(
      {required Map availability, required String artistId}) async {
    final response = await DioClient.client.patch(
        "salon/availability/artist/$artistId/availability",
        data: availability);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*----------------  SalonAvailability --------------- */
  static Future<SalonAvailability> getSalonAvailability() async {
    final response = await DioClient.client.get("salon/availability");
    if (response.isSuccess) {
      return SalonAvailability.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-----------------  Update Salon Availability -------------*/
  static Future<bool> updateSalonAvailability(
      {required Map availability}) async {
    final response =
        await DioClient.client.patch("salon/availability", data: availability);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*---------------- Salon Get  Document -----------*/
  static Future<SalonDocumentGetModel> getSalonDocument() async {
    final response = await DioClient.client.get("salon/onboarding/document");
    if (response.isSuccess) {
      return SalonDocumentGetModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*--------------- Salon Document Submit ---------------*/
  static Future<bool> documentSubmit(
      {required String documentId, required File image}) async {
    final formData = FormData.fromMap({
      "documentId": documentId,
    });

    if (image.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    }

    final response = await DioClient.client
        .put("salon/onboarding/document/upload", data: formData);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-------------------  Salon Artiest  Details ----------------*/
  static Future<ArtiestDetailsModel> getSalonArtiest(
      {required String artistId}) async {
    final response =
        await DioClient.client.get("salon/artist/$artistId/details");
    if (response.isSuccess) {
      return ArtiestDetailsModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*------------------  Salon DashBoard APi ------------*/
  static Future<SalonDashboardModel> getSalonDashBoard(
      {required String distribution}) async {
    final response = await DioClient.client.get("salon/dashboard/analytics",
        queryParameters: {"distribution": distribution});

    if (response.isSuccess) {
      return SalonDashboardModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }
}
