class CategoryDataModel {
  bool? success;
  String? message;
  List<C_Data>? data;

  CategoryDataModel({this.success, this.message, this.data});

  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <C_Data>[];
      json['data'].forEach((v) {
        data!.add(new C_Data.fromJson(v));
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

class C_Data {
  String? icon;
  String? color;
  String? sId;
  String? name;
  int? iV;
  String? id;

  C_Data({this.icon, this.color, this.sId, this.name, this.iV, this.id});

  C_Data.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    color = json['color'];
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['color'] = this.color;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}