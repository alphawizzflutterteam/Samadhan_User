/// error : false
/// message : " sent OTP request!"
/// data : {"email":null,"mobile":"8349922853","otp":1008}

class VerifyUserModel {
  VerifyUserModel({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  VerifyUserModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
VerifyUserModel copyWith({  bool? error,
  String? message,
  Data? data,
}) => VerifyUserModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// email : null
/// mobile : "8349922853"
/// otp : 1008

class Data {
  Data({
      dynamic email, 
      String? mobile, 
      int? otp,}){
    _email = email;
    _mobile = mobile;
    _otp = otp;
}

  Data.fromJson(dynamic json) {
    _email = json['email'];
    _mobile = json['mobile'];
    _otp = json['otp'];
  }
  dynamic _email;
  String? _mobile;
  int? _otp;
Data copyWith({  dynamic email,
  String? mobile,
  int? otp,
}) => Data(  email: email ?? _email,
  mobile: mobile ?? _mobile,
  otp: otp ?? _otp,
);
  dynamic get email => _email;
  String? get mobile => _mobile;
  int? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['otp'] = _otp;
    return map;
  }

}