class BlogDataGetModel {
  int? statusCode;
  bool? success;
  List<BlogData>? data;
  String? message;

  BlogDataGetModel({this.statusCode, this.success, this.data, this.message});

  BlogDataGetModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <BlogData>[];
      json['data'].forEach((v) {
        data!.add(BlogData.fromJson(v));
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

class BlogData {
  String? id;
  String? title;
  String? description;
  String? image;
  String? video;
  String? createdAt;
  String? body;
  int? viewCount;
  int? likeCount;
  String? externalLink;
  Artist? artist;

  BlogData(
      {this.id,
      this.title,
      this.description,
      this.image,
      this.video,
      this.createdAt,
      this.body,
      this.viewCount,
      this.likeCount,
      this.externalLink,
      this.artist});

  BlogData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title'] as String?;
    description = json['description'] as String?;
    image = json['image'];
    video = json['video'];
    createdAt = json['createdAt'] as String?;
    body = json['body'] as String?;
    viewCount = _asInt(json['viewCount']);
    likeCount = _asInt(json['likeCount']);
    externalLink = json['externalLink'] as String?;
    artist = json['artist'] != null
        ? Artist.fromJson(json['artist'] as Map<String, dynamic>)
        : null;
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['video'] = video;
    data['createdAt'] = createdAt;
    data['body'] = body;
    data['viewCount'] = viewCount;
    data['likeCount'] = likeCount;
    data['externalLink'] = externalLink;
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    return data;
  }
}

class Artist {
  String? id;
  String? name;
  String? profileImage;
  Salon? salon;

  Artist({this.id, this.name, this.profileImage, this.salon});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'] as String?;
    profileImage = json['profileImage'] as String?;
    salon = json['salon'] != null
        ? Salon.fromJson(json['salon'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    if (salon != null) {
      data['salon'] = salon!.toJson();
    }
    return data;
  }
}

class Salon {
  String? id;
  String? name;
  String? image;

  Salon({this.id, this.name, this.image});

  Salon.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name'] as String?;
    image = json['image'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
