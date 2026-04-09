class SalonDocumentGetModel {
  int? statusCode;
  bool? success;
  List<DocumentListModel>? data;
  String? message;

  SalonDocumentGetModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonDocumentGetModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <DocumentListModel>[];
      json['data'].forEach((v) {
        data!.add(DocumentListModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class DocumentListModel {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? title;
  bool? isCaptureOnly;
  bool? isRequired;
  int? maxAllowedSize;
  String? placeHolderImage;
  List<SubmittedDocuments>? submittedDocuments;
  bool? isSubmitted;

  DocumentListModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.title,
      this.isCaptureOnly,
      this.isRequired,
      this.maxAllowedSize,
      this.placeHolderImage,
      this.submittedDocuments,
      this.isSubmitted});

  DocumentListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    description = json['description'];
    title = json['title'];
    isCaptureOnly = json['isCaptureOnly'];
    isRequired = json['isRequired'];
    maxAllowedSize = json['maxAllowedSize'];
    placeHolderImage = json['placeHolderImage'];
    if (json['submittedDocuments'] != null) {
      submittedDocuments = <SubmittedDocuments>[];
      json['submittedDocuments'].forEach((v) {
        submittedDocuments!.add(SubmittedDocuments.fromJson(v));
      });
    }
    isSubmitted = json['isSubmitted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['description'] = description;
    data['title'] = title;
    data['isCaptureOnly'] = isCaptureOnly;
    data['isRequired'] = isRequired;
    data['maxAllowedSize'] = maxAllowedSize;
    data['placeHolderImage'] = placeHolderImage;
    if (submittedDocuments != null) {
      data['submittedDocuments'] =
          submittedDocuments!.map((v) => v.toJson()).toList();
    }
    data['isSubmitted'] = isSubmitted;
    return data;
  }
}

class SubmittedDocuments {
  String? id;
  String? documentUrl;
  String? status;
  String? rejectionReason;
  String? verifiedAt;

  SubmittedDocuments(
      {this.id,
      this.documentUrl,
      this.status,
      this.rejectionReason,
      this.verifiedAt});

  SubmittedDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentUrl = json['documentUrl'];
    status = json['status'];
    rejectionReason = json['rejectionReason'];
    verifiedAt = json['verifiedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['documentUrl'] = documentUrl;
    data['status'] = status;
    data['rejectionReason'] = rejectionReason;
    data['verifiedAt'] = verifiedAt;
    return data;
  }
}
