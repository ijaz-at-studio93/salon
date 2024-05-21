import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/home_api.dart';
import 'package:salon/model/service_model/category_list_model.dart';
import 'package:salon/model/service_model/product_list_data_model.dart';
import 'package:salon/model/service_model/salon_service_list_model.dart';
import 'package:salon/model/service_model/service_preview_model.dart';

class HomeController extends GetxController {

  /*---------------  Show  Progressbar --------------*/
  final Rx<bool> _showProgress = false.obs;
  bool get showProgress => _showProgress.value;
  set setShowProgress(val) => _showProgress.value = val;

  final Rx<bool> _showProgressCategory = false.obs;
  bool get showProgressCategory => _showProgressCategory.value;
  set setShowProgressCategory(val) => _showProgressCategory.value = val;

  /*-----------------  Eligibility Store  ---------------*/
  final Rx<bool> _eligibility = false.obs;
  bool get eligibility => _eligibility.value;
  set eligibility(val) => _eligibility.value = val;

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
}
