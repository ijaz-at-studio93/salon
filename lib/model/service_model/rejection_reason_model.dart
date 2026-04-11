class RejectionReasonModel {
  final bool? success;
  final List<RejectionReason>? data;

  RejectionReasonModel({this.success, this.data});

  factory RejectionReasonModel.fromJson(Map<String, dynamic> json) {
    return RejectionReasonModel(
      success: json['success'],
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => RejectionReason.fromJson(e))
              .toList()
          : null,
    );
  }
}

class RejectionReason {
  final String? id;
  final String? code;
  final String? label;

  RejectionReason({this.id, this.code, this.label});

  factory RejectionReason.fromJson(Map<String, dynamic> json) {
    return RejectionReason(
      id: json['id'],
      code: json['code'],
      label: json['label'],
    );
  }

  bool get isOther => code == 'OTHER';
}
