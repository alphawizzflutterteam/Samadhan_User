import 'dart:convert';
/// error : false
/// message : "Pincodes retrieved successfully"
/// total : "1"
/// data : [{"id":"9","zipcode":"400101","date_created":"2022-06-10 14:29:52"}]

GetZipCodeModel getZipCodeModelFromJson(String str) => GetZipCodeModel.fromJson(json.decode(str));
String getZipCodeModelToJson(GetZipCodeModel data) => json.encode(data.toJson());
class GetZipCodeModel {
  GetZipCodeModel({
      bool? error, 
      String? message, 
      String? total, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _total = total;
    _data = data;
}

  GetZipCodeModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _total = json['total'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  String? _total;
  List<Data>? _data;
GetZipCodeModel copyWith({  bool? error,
  String? message,
  String? total,
  List<Data>? data,
}) => GetZipCodeModel(  error: error ?? _error,
  message: message ?? _message,
  total: total ?? _total,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  String? get total => _total;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    map['total'] = _total;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "9"
/// zipcode : "400101"
/// date_created : "2022-06-10 14:29:52"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? zipcode, 
      String? dateCreated,}){
    _id = id;
    _zipcode = zipcode;
    _dateCreated = dateCreated;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _zipcode = json['zipcode'];
    _dateCreated = json['date_created'];
  }
  String? _id;
  String? _zipcode;
  String? _dateCreated;
Data copyWith({  String? id,
  String? zipcode,
  String? dateCreated,
}) => Data(  id: id ?? _id,
  zipcode: zipcode ?? _zipcode,
  dateCreated: dateCreated ?? _dateCreated,
);
  String? get id => _id;
  String? get zipcode => _zipcode;
  String? get dateCreated => _dateCreated;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['zipcode'] = _zipcode;
    map['date_created'] = _dateCreated;
    return map;
  }

}