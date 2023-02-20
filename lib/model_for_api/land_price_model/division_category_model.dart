class DivisionCategory {
  bool? success;
  String? message;
  List<Div_Data>? data;

  DivisionCategory({this.success, this.message, this.data});

  DivisionCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Div_Data>[];
      json['data'].forEach((v) {
        data!.add(new Div_Data.fromJson(v));
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

class Div_Data {
  String? sId;
  String? name;
  String? diviId;
  int? iV;
  String? id;

  Div_Data({this.sId, this.name, this.diviId, this.iV, this.id});

  Div_Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    diviId = json['diviId'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['diviId'] = this.diviId;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}