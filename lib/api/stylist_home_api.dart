import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:salon/model/artist_model/artiest_dashboard_model.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/model/salon_review_model/salon_overall_review_model.dart';
import 'package:salon/model/stylist/allow_portfolio_upload_model.dart';
import 'package:salon/model/stylist/appoimrnt_details_model.dart';
import '../model/stylist/artist_portfolio_model.dart';
import '../model/stylist/pending_appointment.dart';
import 'dio_client.dart';

/// Resolves [MediaType] for multipart uploads: extension first, then magic bytes
/// (matches server `IMAGE_UPLOAD_MIME_TYPES` / `VIDEO_UPLOAD_MIME_TYPES` better
/// than hard-coding JPEG-only headers).
Future<MediaType> _multipartMediaTypeForFile(
  File file, {
  required bool isVideo,
}) async {
  String? mimeStr = lookupMimeType(file.path);
  if (mimeStr == null) {
    final header = await _readUploadFileHeader(file, 32);
    mimeStr = lookupMimeType(file.path, headerBytes: header);
  }
  mimeStr ??= isVideo ? 'video/mp4' : 'image/jpeg';
  final parts = mimeStr.split('/');
  if (parts.length != 2) {
    return MediaType('application', 'octet-stream');
  }
  return MediaType(parts[0], parts[1]);
}

Future<List<int>?> _readUploadFileHeader(File file, int length) async {
  try {
    final raf = await file.open();
    try {
      return await raf.read(length);
    } finally {
      await raf.close();
    }
  } catch (_) {
    return null;
  }
}

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
  static Future<PendingAppointmentsListModel> servedBookingSection(
      {required String distribution}) async {
    final response = await DioClient.client.get(
        "artist/appointments/served-appointments",
        queryParameters: {"distribution": distribution});
    if (response.isSuccess) {
      return PendingAppointmentsListModel.fromJson(response.data);
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
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
        formData.files.add(MapEntry('videos', multipartFile));
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

  /// `PUT /artist/portfolio/sample-portfolio-upload` — multipart `images` /
  /// `videos` (same field names as appointment portfolio upload; server max 10 files).
  static Future<void> uploadSamplePortfolio({
    required List<String> imagePaths,
    required List<String> videoPaths,
  }) async {
    if (imagePaths.isEmpty && videoPaths.isEmpty) {
      throw ArgumentError('Pass at least one file');
    }

    final formData = FormData.fromMap({});

    for (final path in imagePaths) {
      final file = File(path);
      final contentType =
          await _multipartMediaTypeForFile(file, isVideo: false);
      formData.files.add(MapEntry(
        'images',
        await MultipartFile.fromFile(path, contentType: contentType),
      ));
    }
    for (final path in videoPaths) {
      final file = File(path);
      final contentType = await _multipartMediaTypeForFile(file, isVideo: true);
      formData.files.add(MapEntry(
        'videos',
        await MultipartFile.fromFile(path, contentType: contentType),
      ));
    }

    final response = await DioClient.client.put(
      'artist/portfolio/sample-portfolio-upload',
      data: formData,
    );
    if (response.isSuccess) {
      return;
    } else {
      throw response.data;
    }
  }

  /*------------------------ Artiest Add Blog ------------*/
  /// `POST /artist/blog/create` — multipart `image` / `video` (fileParser) +
  /// text fields validated by `createArtistBlogSchema` on the server.
  static Future<bool> addArtiestBlog({
    required String title,
    required String externalLink,
    required String body,
    required String description,
    required File image,
    required File video,
  }) async {
    final formData = FormData.fromMap({
      // "title": title,
      // "body": body,
      "description": description,
      // "externalLink": externalLink
    });

    if (image.path.isNotEmpty) {
      final contentType =
          await _multipartMediaTypeForFile(image, isVideo: false);
      final multipartFile = await MultipartFile.fromFile(
        image.path,
        contentType: contentType,
      );
      formData.files.add(MapEntry('image', multipartFile));
    }

    if (video.path.isNotEmpty) {
      final contentType =
          await _multipartMediaTypeForFile(video, isVideo: true);
      final multipartFile = await MultipartFile.fromFile(
        video.path,
        contentType: contentType,
      );
      formData.files.add(MapEntry('video', multipartFile));
    }

    final response = await DioClient.client.post(
      "artist/blog/create",
      data: formData,
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*------------- Blog Data get -------------*/
  static Future<BlogDataGetModel> getBlogList() async {
    final response = await DioClient.client.get("artist/blog/list");
    if (response.isSuccess) {
      return BlogDataGetModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /// `PUT /artist/blog/:id` — JSON when only text changes; multipart when replacing
  /// `image` / `video` (must match server middleware if files are supported).
  static Future<bool> updateArtistBlog({
    required String blogId,
    String? title,
    String? body,
    String? description,
    String? externalLink,
    File? image,
    File? video,
  }) async {
    final hasImage = image != null && image.path.isNotEmpty;
    final hasVideo = video != null && video.path.isNotEmpty;

    if (hasImage || hasVideo) {
      final formData = FormData.fromMap({
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (description != null) 'description': description,
        if (externalLink != null) 'externalLink': externalLink,
      });
      if (hasImage) {
        final img = image;
        final contentType =
            await _multipartMediaTypeForFile(img, isVideo: false);
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(img.path, contentType: contentType),
        ));
      }
      if (hasVideo) {
        final vid = video;
        final contentType =
            await _multipartMediaTypeForFile(vid, isVideo: true);
        formData.files.add(MapEntry(
          'video',
          await MultipartFile.fromFile(vid.path, contentType: contentType),
        ));
      }
      if (formData.fields.isEmpty && formData.files.isEmpty) {
        throw ArgumentError('updateArtistBlog: empty update');
      }
      final response = await DioClient.client.put(
        'artist/blog/$blogId',
        data: formData,
      );
      if (response.isSuccess) {
        return true;
      } else {
        throw response.data;
      }
    }

    final Map<String, dynamic> data = {
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (description != null) 'description': description,
      if (externalLink != null) 'externalLink': externalLink,
    };
    if (data.isEmpty) {
      throw ArgumentError('updateArtistBlog: pass at least one text field');
    }
    final response =
        await DioClient.client.put('artist/blog/$blogId', data: data);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /// `DELETE /artist/blog/:id`
  static Future<bool> deleteArtistBlog({required String blogId}) async {
    final response = await DioClient.client.delete('artist/blog/$blogId');
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-------------- Get Over all Stylist Review --------------*/
  static Future<OverallReviewListModel> getOverAllStylistReview() async {
    final response = await DioClient.client.get("artist/review/overall/list");
    if (response.isSuccess) {
      return OverallReviewListModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*---------------- get Artiest Model --------------------*/
  static Future<ArtiestDashboardModel> getStylistDashBoard(
      {required String distribution}) async {
    final response = await DioClient.client.get("artist/dashboard/analytics",
        queryParameters: {"distribution": distribution});

    if (response.isSuccess) {
      return ArtiestDashboardModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  /*-----------------  get  Artiest  Portfolio ------------------------*/
  static Future<ArtistPortfolioModel> getArtiestPortfolio() async {
    final response = await DioClient.client.get(
      "artist/portfolio/",
    );

    if (response.isSuccess) {
      return ArtistPortfolioModel.fromJson(response.data);
    } else {
      throw response.data;
    }
  }

  static Future<bool> createPortFolio({
    required bool isImage,
    required File image,
    required File video,
  }) async {
    final formData = FormData.fromMap({});

    if (isImage) {
      print("Image Path ${image.path}");
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    } else {
      print("Video Path ${video.path}");
      final mimeTypeData = lookupMimeType(video.path, headerBytes: [
        0x00,
        0x00,
        0x00,
        0x00,
        0x66,
        0x74,
        0x79,
        0x70,
        0x61,
        0x76,
        0x63,
        0x31
      ])?.split('/');
      final multipartFile = await MultipartFile.fromFile(video.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('video', multipartFile));
    }

    final response = await DioClient.client.post(
      "artist/portfolio",
      data: formData,
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*-------------------  Update  PortFolio ------------------*/
  static Future<bool> updatePortFolio({
    required String portfolioId,
    required bool isImage,
    required File image,
    required File video,
  }) async {
    final formData = FormData.fromMap({});

    print(
        "isImage $isImage  video ${video.path}  image Path ${image.path} ID $portfolioId");

    if (isImage) {
      print("Image Path ${image.path}");
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final multipartFile = await MultipartFile.fromFile(image.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('image', multipartFile));
    } else {
      print("Video Path ${video.path}");
      final mimeTypeData = lookupMimeType(video.path, headerBytes: [
        0x00,
        0x00,
        0x00,
        0x00,
        0x66,
        0x74,
        0x79,
        0x70,
        0x61,
        0x76,
        0x63,
        0x31
      ])?.split('/');
      final multipartFile = await MultipartFile.fromFile(video.path,
          contentType: MediaType(mimeTypeData![0], mimeTypeData[1]));
      formData.files.add(MapEntry('video', multipartFile));
    }

    final response = await DioClient.client.patch(
      "artist/portfolio/$portfolioId",
    );

    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }

  /*----------------- Update Time Slot For Booking --------------------*/
  static Future<bool> updateBookingTimeSlat(
      {required String appointmentId, required Map changeMinutes}) async {
    final response = await DioClient.client.patch(
        "artist/appointments/$appointmentId/time-slot",
        data: changeMinutes);
    if (response.isSuccess) {
      return true;
    } else {
      throw response.data;
    }
  }
}
