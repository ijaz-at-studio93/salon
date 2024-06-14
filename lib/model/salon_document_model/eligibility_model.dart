class EligibilityModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  EligibilityModel({this.statusCode, this.success, this.data, this.message});

  EligibilityModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  bool? isApproved;
  DocumentData? documentData;

  Data({this.isApproved, this.documentData});

  Data.fromJson(Map<String, dynamic> json) {
    isApproved = json['isApproved'];
    documentData = json['documentData'] != null
        ? DocumentData.fromJson(json['documentData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isApproved'] = isApproved;
    if (documentData != null) {
      data['documentData'] = documentData!.toJson();
    }
    return data;
  }
}

class DocumentData {
  int? salonDocumentCount;
  int? submittedDocumentCount;
  bool? isAllSubmitted;
  bool? isAllVerified;

  DocumentData(
      {this.salonDocumentCount,
      this.submittedDocumentCount,
      this.isAllSubmitted,
      this.isAllVerified});

  DocumentData.fromJson(Map<String, dynamic> json) {
    salonDocumentCount = json['salonDocumentCount'];
    submittedDocumentCount = json['submittedDocumentCount'];
    isAllSubmitted = json['isAllSubmitted'];
    isAllVerified = json['isAllVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salonDocumentCount'] = salonDocumentCount;
    data['submittedDocumentCount'] = submittedDocumentCount;
    data['isAllSubmitted'] = isAllSubmitted;
    data['isAllVerified'] = isAllVerified;
    return data;
  }
}
