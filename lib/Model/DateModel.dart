/// error : false
/// message : "Otp Send Successfully"
/// data : [{"total":"1","delivery_time":"9:00 To 14:00","id":"3","limit":"100","status":false}]

class DateModel {
  DateModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  DateModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Data>? _data;
DateModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => DateModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// total : "1"
/// delivery_time : "9:00 To 14:00"
/// id : "3"
/// limit : "100"
/// status : false

class Data {
  Data({
      String? total, 
      String? deliveryTime, 
      String? id, 
      String? limit, 
      String? status,}){
    _total = total;
    _deliveryTime = deliveryTime;
    _id = id;
    _limit = limit;
    _status = status;
}

  Data.fromJson(dynamic json) {
    _total = json['total_order'];
    _deliveryTime = json['title'];
    _id = json['id'];
    _limit = json['limit'];
    _status = json['status'];
  }
  String? _total;
  String? _deliveryTime; 
  String? _id;
  String? _limit;
  String? _status;
Data copyWith({  String? total,
  String? deliveryTime,
  String? id,
  String? limit,
  String? status,
}) => Data(  total: total ?? _total,
  deliveryTime: deliveryTime ?? _deliveryTime,
  id: id ?? _id,
  limit: limit ?? _limit,
  status: status ?? _status,
);
  String? get total => _total;
  String? get deliveryTime => _deliveryTime;
  String? get id => _id;
  String? get limit => _limit;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_order'] = _total;
    map['title'] = _deliveryTime;
    map['id'] = _id;
    map['limit'] = _limit;
    map['status'] = _status;
    return map;
  }

}