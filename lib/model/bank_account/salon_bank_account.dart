class SalonBankAccountList {
  int? statusCode;
  bool? success;
  List<Data>? data;
  String? message;

  SalonBankAccountList(
      {this.statusCode, this.success, this.data, this.message});

  SalonBankAccountList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? salonId;
  String? accountType;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? branchName;
  String? accountHolderName;
  bool? isPrimary;
  String? bankIconImage;

  Data(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.salonId,
        this.accountType,
        this.accountNumber,
        this.ifscCode,
        this.bankName,
        this.branchName,
        this.accountHolderName,
        this.isPrimary,
        this.bankIconImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    salonId = json['salonId'];
    accountType = json['accountType'];
    accountNumber = json['accountNumber'];
    ifscCode = json['ifscCode'];
    bankName = json['bankName'];
    branchName = json['branchName'];
    accountHolderName = json['accountHolderName'];
    isPrimary = json['isPrimary'];
    bankIconImage = json['bankIconImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['salonId'] = salonId;
    data['accountType'] = accountType;
    data['accountNumber'] = accountNumber;
    data['ifscCode'] = ifscCode;
    data['bankName'] = bankName;
    data['branchName'] = branchName;
    data['accountHolderName'] = accountHolderName;
    data['isPrimary'] = isPrimary;
    data['bankIconImage'] = bankIconImage;
    return data;
  }
}