class DistrictCategory {
  bool? success;
  String? message;
  List<Dis_Data>? data;

  DistrictCategory({this.success, this.message, this.data});

  DistrictCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Dis_Data>[];
      json['data'].forEach((v) {
        data!.add(new Dis_Data.fromJson(v));
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

class Dis_Data {
  String? sId;
  String? name;
  String? districtId;
  String? diviId;
  String? divisionId;
  int? iV;
  String? id;

  Dis_Data(
      {this.sId,
        this.name,
        this.districtId,
        this.diviId,
        this.divisionId,
        this.iV,
        this.id});

  Dis_Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    districtId = json['districtId'];
    diviId = json['diviId'];
    divisionId = json['divisionId'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['districtId'] = this.districtId;
    data['diviId'] = this.diviId;
    data['divisionId'] = this.divisionId;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}