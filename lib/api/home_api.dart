import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:salon/api/api_end_point.dart';
import 'package:salon/api/dio_client.dart';
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
import 'package:salon/model/translation/translation_history_model.dart';

import '../model/stylist/allow_portfolio_upload_model.dart';
import '../model/service_model/rejection_reason_model.dart';

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

  /*======================= delete Product ===================*/
  static Future<bool> deleteProduct({required String productId}) async {
    final response =
        await DioClient.client.delete("salon/product/$productId/delete");
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*===================== Delete Artiest =====================*/
  static Future<bool> deleteStylist({required String artistId}) async {
    final response =
        await DioClient.client.delete("salon/artist/$artistId/delete");
    if (response.isSuccess) {
      return true;
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
      "description": description,
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
    required File? image,
    String? serviceCategoryId,
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "description": description,
      if (serviceCategoryId != null && serviceCategoryId.isNotEmpty)
        "serviceCategoryId": serviceCategoryId,
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
  }) async {
    final List<MultipartFile> files = [];

    if (image.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      files.add(await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1])));
    }

    for (final file in portfolioFiles) {
      if (file.path.isEmpty) continue;
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])?.split('/');
      if (mimeTypeData == null || mimeTypeData.length < 2) continue;
      files.add(await MultipartFile.fromFile(file.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
    }

    final formData = FormData.fromMap({
      "name": name,
      "sId": sId,
      "mobile": mobile,
      "countryCode": countryCode,
      "password": password,
      "gender": gender,
      "profession": profession,
      "homeService": homeService,
      "files": files,
    });

    for (int i = 0; i < languagesKnown.length; i++) {
      formData.fields.add(MapEntry("languagesKnown[$i]", languagesKnown[i]));
    }

    // if (storeId.isNotEmpty) {
    //   for (int i = 0; i < storeId.length; i++) {
    //     formData.fields.add(MapEntry("salonService[$i][id]", storeId[i]));
    //     formData.fields.add(
    //         MapEntry("salonService[$i][serviceableGender]", genderDataList[i]));
    //   }
    // }

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
    required String experience,
    required String whatsapp,
    required String homeService,
    required String gender,
    required File image,
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "mobile": mobile,
      "countryCode": countryCode,
      "experience": experience,
      "whatsapp": whatsapp,
      "homeService": homeService,
      "gender": gender,
    });

    if (image.path.isNotEmpty) {
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('file', multipartFile));
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

  /*---------------  Salon Content List  -------------*/
  static Future<BlogDataGetModel> getSalonContentList() async {
    final response = await DioClient.client.get(APIEndPoint.salonContentList);
    if (response.isSuccess) {
      return BlogDataGetModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*---------------  Salon Content Add  -------------*/
  static Future<bool> createSalonContent({
    required String description,
    File? content,
  }) async {
    if (content == null || content.path.isEmpty) return false;

    final formData = FormData.fromMap({
      "description": description,
    });

    final mimeType = lookupMimeType(content.path) ?? 'application/octet-stream';
    final mimeTypeParts = mimeType.split('/');

    final multipartFile = await MultipartFile.fromFile(
      content.path,
      contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
    );
    formData.files.add(MapEntry('file', multipartFile));

    final response = await DioClient.client
        .post(APIEndPoint.salonContentAdd, data: formData);

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*---------------  Menu Change Request  -------------*/
  static Future<bool> submitMenuChangeRequest({
    required String filePath,
  }) async {
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final mimeTypeParts = mimeType.split('/');

    final multipartFile = await MultipartFile.fromFile(
      filePath,
      contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
    );

    final formData = FormData.fromMap({});
    formData.files.add(MapEntry('file', multipartFile));

    final response = await DioClient.client
        .post(APIEndPoint.menuChangeRequest, data: formData);

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  static Future<bool> getMenuChangeRequest() async {
    final response = await DioClient.client.get(APIEndPoint.menuChangeRequest);
    return response.isSuccess;
  }

  /*---------------  Salon Content Update  -------------*/
  static Future<bool> updateSalonContent({
    required String contentId,
    String? description,
    File? file,
    bool isVideo = false,
  }) async {
    dynamic data;

    if (file != null) {
      // Only use multipart when a new file is actually being uploaded.
      // The PUT route must have a file parser middleware for this to work.
      final mimeTypeData = isVideo
          ? lookupMimeType(file.path)?.split('/')
          : lookupMimeType(file.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final formData = FormData.fromMap({
        if (description != null && description.isNotEmpty)
          'description': description,
      });
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(file.path,
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1])),
      ));
      data = formData;
    } else {
      // No file — send plain JSON so the server body-parser can read it.
      data = {
        if (description != null && description.isNotEmpty)
          'description': description,
      };
    }

    final response =
        await DioClient.client.put("salon/blog/$contentId", data: data);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*---------------  Salon Content Delete  -------------*/
  static Future<bool> deleteSalonContent({required String contentId}) async {
    final response = await DioClient.client.delete("salon/blog/$contentId");
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*--------------------------- Get Pending Appointments Model ---------------------*/
  static Future<PendingAppointmentsListModel> getPendingAppointments({
    String distribution = 'today',
  }) async {
    final response = await DioClient.client.get(
      "salon/appointments/pending-appointments",
      queryParameters: {'distribution': distribution},
    );
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-----------------------  Booking Approve -----------------------------*/
  static Future<bool> approveBooking({
    required String appointmentId,
    required String status,
    List<String>? stylistIds,
    String? startsAt,
    String? endsAt,
    String? rejectionReasonId,
    String? rejectionNote,
  }) async {
    final body = <String, dynamic>{'status': status};
    if (stylistIds != null && stylistIds.isNotEmpty) {
      body['stylistIds'] = stylistIds;
    }
    if (startsAt != null && startsAt.isNotEmpty) {
      body['startsAt'] = startsAt;
    }
    if (endsAt != null && endsAt.isNotEmpty) {
      body['endsAt'] = endsAt;
    }
    if (rejectionReasonId != null && rejectionReasonId.isNotEmpty) {
      body['rejectionReasonId'] = rejectionReasonId;
    }
    if (rejectionNote != null && rejectionNote.isNotEmpty) {
      body['rejectionNote'] = rejectionNote;
    }
    final response = await DioClient.client
        .put("salon/appointments/$appointmentId/status", data: body);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-----------------------  Get Rejection Reasons -----------------------------*/
  static Future<RejectionReasonModel> getRejectionReasons() async {
    final response =
        await DioClient.client.get("salon/appointments/rejection-reason");
    if (response.isSuccess) {
      return RejectionReasonModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*---------------  Booking For Qr Code Scan ----------------*/
  static Future<AllowPortfolioUploadModel> qrcodeScan(
      {required String appointmentId}) async {
    final response = await DioClient.client.put(
        "salon/appointments/complete-with-completion-token",
        data: {"appointmentId": appointmentId});
    if (response.data['success']) {
      return AllowPortfolioUploadModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-------------------- Upload Image -------------------------*/
  static Future<String> uploadImage({
    required String appointmentId,
    required List<String> multiplePath,
    required List<String> multipleVideo,
  }) async {
    final formData = FormData.fromMap({});

    if (multiplePath.isNotEmpty) {
      for (int i = 0; i < multiplePath.length; i++) {
        final mimeTypeData =
            lookupMimeType(multiplePath[i], headerBytes: [0xFF, 0xD8])
                ?.split('/');
        final multipartFile = await MultipartFile.fromFile(multiplePath[i],
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        formData.files.add(MapEntry('images', multipartFile));
      }
    }

    if (multipleVideo.isNotEmpty) {
      for (int i = 0; i < multipleVideo.length; i++) {
        final mimeTypeData = lookupMimeType(multipleVideo[i])?.split('/');
        final multipartFile = await MultipartFile.fromFile(multipleVideo[i],
            contentType: MediaType(mimeTypeData![0], multipleVideo[1]));
        formData.files.add(MapEntry('videos', multipartFile));
      }
    }

    final response = await DioClient.client.put(
        'salon/appointments/$appointmentId/portfolio-upload',
        data: formData);
    if (response.isSuccess) {
      return response.data['message'];
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

  /*------------------- All Salon Staff List ----------------------*/
  static Future<AllSalonStaffModel> getAllSalonStaffList() async {
    final response = await DioClient.client.get("salon/artist/all-salon-list");
    if (response.isSuccess) {
      return AllSalonStaffModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*------------------- Add Existing Artist by SId ----------------------*/
  static Future<bool> addExistingArtistBySId({required String sId}) async {
    final response = await DioClient.client.post(
      "salon/artist/import",
      data: {"sId": sId},
    );
    if (response.isSuccess) {
      return true;
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

  /*---------------  Artiest Availability  Get Data ------------- */
  static Future<ArtiestAvailabilityGetModel> blockSlotForArtist(
      {required String artistId,
      required DateTime? start,
      required DateTime? end}) async {
    final response = await DioClient.client.post(
      "salon/availability/artist/$artistId/block-slot",
      data: {
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
      },
    );
    if (response.isSuccess) {
      return ArtiestAvailabilityGetModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /// Removes a blocked interval. Requires the slot id from [ArtistBlockedSlot.id].
  static Future<bool> deleteArtistBlockedSlot({
    required String artistId,
    required String blockId,
  }) async {
    final response = await DioClient.client.delete(
      "salon/availability/artist/$artistId/blocked-slots/$blockId",
    );
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*---------- Get Blocked Slots For Artist ----------*/
  static Future<List<ArtistBlockedSlot>> getBlockedSlotsForArtist(
      {required String artistId}) async {
    final response = await DioClient.client
        .get("salon/availability/artist/$artistId/blocked-slots");
    if (response.isSuccess) {
      final data = response.data['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((e) => ArtistBlockedSlot.fromJson(e))
            .where((s) => s.start != null && s.end != null)
            .toList();
      }
      return [];
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

  /*----------------  Transaction  history API --------------*/
  static Future<TransactionsHistoryModel> getTransactionHistory(
      {required String distribution}) async {
    final response = await DioClient.client.get("salon/transactions/settled",
        queryParameters: {"distribution": distribution});
    if (response.isSuccess) {
      return TransactionsHistoryModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*----------------------  TransactionUnsettledHistory -----------------------*/
  static Future<TransactionsHistoryModel> getTransactionUnsettledHistory(
      {required String distribution}) async {
    final response = await DioClient.client.get("salon/transactions/unsettled",
        queryParameters: {"distribution": distribution});
    if (response.isSuccess) {
      return TransactionsHistoryModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*------------------  My Details page  Salon  Service By  Category -------------------*/
  static Future<SettingSalonServiceListModel>
      getSalonServiceByCategory() async {
    final response = await DioClient.client.get(
      "salon/service/categorized-list",
    );
    if (response.isSuccess) {
      return SettingSalonServiceListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*===============================  Salon Category ===============================*/
  static Future<SalonCategoryListModel> getSalonCategory() async {
    final response = await DioClient.client.get(
      "salon/category/list",
    );
    if (response.isSuccess) {
      return SalonCategoryListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*---------------- Add Category ---------------- */
  static Future<bool> addSalonCategory({
    required String name,
    required String description,
    required String serviceableGender,
    required String profession,
    required File? maleImage,
    required File? femaleImage,
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "description": description,
      "serviceableGender": serviceableGender,
      "profession": profession
    });

    if (maleImage != null) {
      final mimeTypeData =
          lookupMimeType(maleImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(maleImage.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('imageMale', multipartFile));
    }

    if (femaleImage != null) {
      final mimeTypeData =
          lookupMimeType(femaleImage.path, headerBytes: [0xFF, 0xD8])
              ?.split('/');
      final multipartFile = await MultipartFile.fromFile(femaleImage.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('imageFemale', multipartFile));
    }

    final response =
        await DioClient.client.post("salon/category/create", data: formData);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*----------------------- Delete Salon Category -----------------*/
  static Future<bool> deleteSalonCategory(
      {required String salonCategoryId}) async {
    final response =
        await DioClient.client.delete("salon/category/$salonCategoryId/delete");
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*--------------------- Do Update Category ---------------*/
  static Future<bool> salonUpdateCategory({
    required String name,
    required String description,
    required String serviceableGender,
    required String salonCategoryId,
    required File? maleImage,
    required File? femaleImage,
  }) async {
    final formData = FormData.fromMap({
      "name": name,
      "description": description,
      "serviceableGender": serviceableGender
    });

    if (maleImage != null) {
      final mimeTypeData =
          lookupMimeType(maleImage.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(maleImage.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('imageMale', multipartFile));
    }

    if (femaleImage != null) {
      final mimeTypeData =
          lookupMimeType(femaleImage.path, headerBytes: [0xFF, 0xD8])
              ?.split('/');
      final multipartFile = await MultipartFile.fromFile(femaleImage.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('imageFemale', multipartFile));
    }

    final response = await DioClient.client
        .patch("salon/category/$salonCategoryId/update", data: formData);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*---------------------- Master List All Bank -----------------------*/
  // static Future<List<ListAllBankModel>> getListBankListData() async {
  //   final response = await DioClient.client.get('common/bank/list-all-bank');
  //   if (response.isSuccess) {
  //     return response.data['data']
  //         .map<ListAllBankModel>((e) => ListAllBankModel.fromJson(e))
  //         .toList();
  //   } else {
  //     throw response.data;
  //   }
  // }

  /*-------------------  get Salon  bank Account -------------------*/
  static Future<SalonBankAccountList> getSalonBankAccount() async {
    final response = await DioClient.client.get("salon/account");
    if (response.isSuccess) {
      return SalonBankAccountList.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*--------------------- Create Add Bank Account ------------------------*/
  static Future<bool> salonAccountCreate({required Map account}) async {
    final response =
        await DioClient.client.post('salon/account', data: account);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-------------------------  Delete Account ------------------*/
  static Future<bool> deleteBankAccount({required String accountId}) async {
    final response = await DioClient.client.delete('salon/account/$accountId');
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }
}
