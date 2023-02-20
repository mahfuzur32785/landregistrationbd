class MyQuestion {
  bool? success;
  String? message;
  List<MyQ_Data>? data;

  MyQuestion({this.success, this.message, this.data});

  MyQuestion.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyQ_Data>[];
      json['data'].forEach((v) {
        data!.add(new MyQ_Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyQ_Data {
  String? sId;
  UserId? userId;
  String? categoryId;
  String? title;
  String? description;
  int? likeCount;
  int? followCount;
  int? answerCount;
  String? createdAt;
  int? iV;
  String? id;

  MyQ_Data(
      {this.sId,
        this.userId,
        this.categoryId,
        this.title,
        this.description,
        this.likeCount,
        this.followCount,
        this.answerCount,
        this.createdAt,
        this.iV,
        this.id});

  MyQ_Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    categoryId = json['categoryId'];
    title = json['title'];
    description = json['description'];
    likeCount = json['likeCount'];
    followCount = json['followCount'];
    answerCount = json['answerCount'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['categoryId'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['likeCount'] = this.likeCount;
    data['followCount'] = this.followCount;
    data['answerCount'] = this.answerCount;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class UserId {
  String? sId;
  String? name;
  String? profileImageUrl;
  String? id;

  UserId({this.sId, this.name, this.profileImageUrl, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImageUrl = json['profileImageUrl'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['profileImageUrl'] = this.profileImageUrl;
    data['id'] = this.id;
    return data;
  }
}