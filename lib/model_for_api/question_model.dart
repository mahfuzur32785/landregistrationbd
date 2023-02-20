class QuestionDataModel {
  bool? success;
  String? message;
  int? totalItem;
  int? totalPages;
  int? currentPage;
  int? pageItemCount;
  List<Q_Data>? data;

  QuestionDataModel(
      {this.success,
        this.message,
        this.totalItem,
        this.totalPages,
        this.currentPage,
        this.pageItemCount,
        this.data});

  QuestionDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    totalItem = json['totalItem'];
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    pageItemCount = json['pageItemCount'];
    if (json['data'] != null) {
      data = <Q_Data>[];
      json['data'].forEach((v) {
        data!.add(new Q_Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['totalItem'] = this.totalItem;
    data['totalPages'] = this.totalPages;
    data['currentPage'] = this.currentPage;
    data['pageItemCount'] = this.pageItemCount;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Q_Data {
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
  bool? like;

  Q_Data(
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
        this.like});

  Q_Data.fromJson(Map<String, dynamic> json) {
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
    like = json['like'];
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
    data['like'] = this.like;
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