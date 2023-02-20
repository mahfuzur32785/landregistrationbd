class UserDataModel {
  bool? success;
  String? message;
  U_Data? data;

  UserDataModel({this.success, this.message, this.data});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new U_Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class U_Data {
  String? sId;
  String? name;
  String? email;
  String? countryCode;
  String? mobile;
  String? mobileWithCountryCode;
  bool? isAdmin;
  bool? isSubAdmin;
  bool? isUser;
  String? country;
  String? latitude;
  String? longitude;
  String? ip;
  String? presentAddress;
  String? parmanentAddress;
  String? gender;
  String? dob;
  String? profileImageUrl;
  bool? isActive;
  int? iV;
  String? createdAt;
  String? id;

  U_Data(
      {this.sId,
        this.name,
        this.email,
        this.countryCode,
        this.mobile,
        this.mobileWithCountryCode,
        this.isAdmin,
        this.isSubAdmin,
        this.isUser,
        this.country,
        this.latitude,
        this.longitude,
        this.ip,
        this.presentAddress,
        this.parmanentAddress,
        this.gender,
        this.dob,
        this.profileImageUrl,
        this.isActive,
        this.iV,
        this.createdAt,
        this.id});

  U_Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    mobileWithCountryCode = json['mobileWithCountryCode'];
    isAdmin = json['isAdmin'];
    isSubAdmin = json['isSubAdmin'];
    isUser = json['isUser'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    ip = json['ip'];
    presentAddress = json['presentAddress'];
    parmanentAddress = json['parmanentAddress'];
    gender = json['gender'];
    dob = json['dob'];
    profileImageUrl = json['profileImageUrl'];
    isActive = json['isActive'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['mobile'] = this.mobile;
    data['mobileWithCountryCode'] = this.mobileWithCountryCode;
    data['isAdmin'] = this.isAdmin;
    data['isSubAdmin'] = this.isSubAdmin;
    data['isUser'] = this.isUser;
    data['country'] = this.country;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['ip'] = this.ip;
    data['presentAddress'] = this.presentAddress;
    data['parmanentAddress'] = this.parmanentAddress;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['profileImageUrl'] = this.profileImageUrl;
    data['isActive'] = this.isActive;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}