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
  final String? reason;

  RejectionReason({this.id, this.reason});

  factory RejectionReason.fromJson(Map<String, dynamic> json) {
    return RejectionReason(
      id: json['id'],
      reason: json['reason'] ?? json['name'],
    );
  }
}
