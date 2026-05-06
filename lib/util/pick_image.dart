import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FileUtils {
  static openPlatformImagePicker(
      {required Function(File) onSelectImage}) async {
    File selectedImage = await openCameraForImage();
    onSelectImage.call(selectedImage);
  }

  static openPlatformVideoPicker(
      {required Function(File) onSelectVideo}) async {
    File selectedVideo = await openCameraForVideo();
    onSelectVideo.call(selectedVideo);
  }

  /*---------------   Pick  Image Camera  ---------------*/
  static Future<File> openCameraForImage() async {
    XFile? file = await (ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 30));
    return File(file!.path);
  }

/*---------------   Pick  Image Gallery  ---------------*/
  static Future<File> pickImageFromGallery() async {
    XFile? file = await (ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30));
    return File(file!.path);
  }

  /*---------------  Open  Camera  For  Video  ---------------*/
  static Future<File> openCameraForVideo() async {
    XFile? file = await (ImagePicker().pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(seconds: 30)));
    return File(file!.path);
  }

/*---------------  Open  Camera  For  Gallery  ---------------*/
  static Future<File> pickVideoGallery() async {
    XFile? file = await (ImagePicker().pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(seconds: 30)));
    return File(file!.path);
  }
}
