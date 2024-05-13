class LoginModel {
  String? status;
  LoginData? data;

  LoginModel({this.status, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  int? result;
  int? role;
  String? userId;
  String? personId;
  String? schoolId;
  bool? isNew;
  String? message;
  String? authToken;
  String? personName;
  String? personCode;
  List<Students>? students;

  LoginData(
      {this.result,
      this.role,
      this.userId,
      this.personId,
      this.schoolId,
      this.isNew,
      this.message,
      this.authToken,
      this.personName,
      this.personCode,
      this.students});

  LoginData.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    role = json['role'];
    userId = json['userId'];
    personId = json['personId'];
    schoolId = json['schoolId'];
    isNew = json['isNew'];
    message = json['message'];
    authToken = json['authToken'];
    personName = json['personName'];
    personCode = json['personCode'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(new Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['role'] = this.role;
    data['userId'] = this.userId;
    data['personId'] = this.personId;
    data['schoolId'] = this.schoolId;
    data['isNew'] = this.isNew;
    data['message'] = this.message;
    data['authToken'] = this.authToken;
    data['personName'] = this.personName;
    data['personCode'] = this.personCode;
    if (this.students != null) {
      data['students'] = this.students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  String? id;
  String? firstName;
  String? fullName;
  String? number;
  String? nowIn;
  int? sts;
  String? stsText;
  String? sch;
  String? gen;
  String? sId;
  String? img;
  String? font;
  String? back;

  Students(
      {this.id,
      this.firstName,
      this.fullName,
      this.number,
      this.nowIn,
      this.sts,
      this.stsText,
      this.sch,
      this.gen,
      this.sId,
      this.img,
      this.font,
      this.back});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    fullName = json['fullName'];
    number = json['number'];
    nowIn = json['nowIn'];
    sts = json['sts'];
    stsText = json['stsText'];
    sch = json['sch'];
    gen = json['gen'];
    sId = json['sId'];
    img = json['img'];
    font = json['font'];
    back = json['back'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['fullName'] = this.fullName;
    data['number'] = this.number;
    data['nowIn'] = this.nowIn;
    data['sts'] = this.sts;
    data['stsText'] = this.stsText;
    data['sch'] = this.sch;
    data['gen'] = this.gen;
    data['sId'] = this.sId;
    data['img'] = this.img;
    data['font'] = this.font;
    data['back'] = this.back;
    return data;
  }
}
