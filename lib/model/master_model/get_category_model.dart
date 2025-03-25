class GetCategoryData {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;
  String? description;
  String? serviceableGender;
  String? imageFemale;
  String? imageMale;
  bool? isSelect;

  GetCategoryData(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.name,
        this.description,
        this.serviceableGender,
        this.imageFemale,
        this.imageMale,
        this.isSelect});

  GetCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    name = json['name'];
    description = json['description'];
    serviceableGender = json['serviceableGender'];
    imageFemale = json['imageFemale'];
    imageMale = json['imageMale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['name'] = name;
    data['description'] = description;
    data['serviceableGender'] = serviceableGender;
    data['imageFemale'] = imageFemale;
    data['imageMale'] = imageMale;
    return data;
  }
}
