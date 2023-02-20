class OfficeCategory {
  bool? success;
  String? message;
  List<Off_Data>? data;

  OfficeCategory({this.success, this.message, this.data});

  OfficeCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Off_Data>[];
      json['data'].forEach((v) {
        data!.add(new Off_Data.fromJson(v));
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

class Off_Data {
  String? sId;
  String? name;
  String? officeId;
  String? diviId;
  String? divisionId;
  String? distId;
  String? districtId;
  int? iV;
  String? id;

  Off_Data(
      {this.sId,
        this.name,
        this.officeId,
        this.diviId,
        this.divisionId,
        this.distId,
        this.districtId,
        this.iV,
        this.id});

  Off_Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    officeId = json['officeId'];
    diviId = json['diviId'];
    divisionId = json['divisionId'];
    distId = json['distId'];
    districtId = json['districtId'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['officeId'] = this.officeId;
    data['diviId'] = this.diviId;
    data['divisionId'] = this.divisionId;
    data['distId'] = this.distId;
    data['districtId'] = this.districtId;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}