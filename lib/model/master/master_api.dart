class ListAllBankModel {
  String? name;
  String? bankIconImage;

  ListAllBankModel({this.name, this.bankIconImage});

  ListAllBankModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bankIconImage = json['bankIconImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['bankIconImage'] = bankIconImage;
    return data;
  }
}
