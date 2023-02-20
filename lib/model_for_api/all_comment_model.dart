class CommentDataModel {
  bool? success;
  String? message;
  List<Comment_Data>? data;

  CommentDataModel({this.success, this.message, this.data});

  CommentDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Comment_Data>[];
      json['data'].forEach((v) {
        data!.add(new Comment_Data.fromJson(v));
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

class Comment_Data {
  String? sId;
  UserId? userId;
  String? questionId;
  String? comment;
  int? likeCount;
  String? createdAt;
  int? iV;
  bool? like;

  Comment_Data(
      {this.sId,
        this.userId,
        this.questionId,
        this.comment,
        this.likeCount,
        this.createdAt,
        this.iV,
        this.like});

  Comment_Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    questionId = json['questionId'];
    comment = json['comment'];
    likeCount = json['likeCount'];
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
    data['questionId'] = this.questionId;
    data['comment'] = this.comment;
    data['likeCount'] = this.likeCount;
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