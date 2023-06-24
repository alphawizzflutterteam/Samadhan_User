/// error : false
/// message : "get Successfully"
/// data : [{"id":"3","title":"12:00 To 13:00","from_time":"12:00:00","to_time":"13:00:00","last_order_time":"10:00:00","status":"1","limit":"3","total_order":"4"},{"id":"22","title":"17:00 To 18:00","from_time":"17:00:00","to_time":"18:00:00","last_order_time":"15:00:00","status":"1","limit":"3","total_order":"0"},{"id":"12","title":"13:00 To 14:00","from_time":"13:00:00","to_time":"14:00:00","last_order_time":"11:00:00","status":"1","limit":"3","total_order":"0"},{"id":"20","title":"15:00 To 16:00","from_time":"15:00:00","to_time":"16:00:00","last_order_time":"13:00:00","status":"1","limit":"3","total_order":"0"},{"id":"21","title":"16:00 To 17:00","from_time":"16:00:00","to_time":"17:00:00","last_order_time":"14:00:00","status":"1","limit":"3","total_order":"0"},{"id":"19","title":"14:00 to 15:00","from_time":"14:00:00","to_time":"15:00:00","last_order_time":"12:00:00","status":"1","limit":"3","total_order":"0"},{"id":"23","title":"18:00 To 19:00","from_time":"18:00:00","to_time":"19:00:00","last_order_time":"16:00:00","status":"1","limit":"3","total_order":"0"},{"id":"24","title":"19:00 To 20:00","from_time":"19:00:00","to_time":"20:00:00","last_order_time":"18:00:00","status":"1","limit":"3","total_order":"0"}]

class NewDateModel {
  NewDateModel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  NewDateModel.fromJson(dynamic json) {
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
NewDateModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => NewDateModel(  error: error ?? _error,
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

/// id : "3"
/// title : "12:00 To 13:00"
/// from_time : "12:00:00"
/// to_time : "13:00:00"
/// last_order_time : "10:00:00"
/// status : "1"
/// limit : "3"
/// total_order : "4"

class Data {
  Data({
      String? id, 
      String? title, 
      String? fromTime, 
      String? toTime, 
      String? lastOrderTime, 
      String? status, 
      String? limit, 
      String? totalOrder,}){
    _id = id;
    _title = title;
    _fromTime = fromTime;
    _toTime = toTime;
    _lastOrderTime = lastOrderTime;
    _status = status;
    _limit = limit;
    _totalOrder = totalOrder;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _fromTime = json['from_time'];
    _toTime = json['to_time'];
    _lastOrderTime = json['last_order_time'];
    _status = json['status'];
    _limit = json['limit'];
    _totalOrder = json['total_order'];
  }
  String? _id;
  String? _title;
  String? _fromTime;
  String? _toTime;
  String? _lastOrderTime;
  String? _status;
  String? _limit;
  String? _totalOrder;
Data copyWith({  String? id,
  String? title,
  String? fromTime,
  String? toTime,
  String? lastOrderTime,
  String? status,
  String? limit,
  String? totalOrder,
}) => Data(  id: id ?? _id,
  title: title ?? _title,
  fromTime: fromTime ?? _fromTime,
  toTime: toTime ?? _toTime,
  lastOrderTime: lastOrderTime ?? _lastOrderTime,
  status: status ?? _status,
  limit: limit ?? _limit,
  totalOrder: totalOrder ?? _totalOrder,
);
  String? get id => _id;
  String? get title => _title;
  String? get fromTime => _fromTime;
  String? get toTime => _toTime;
  String? get lastOrderTime => _lastOrderTime;
  String? get status => _status;
  String? get limit => _limit;
  String? get totalOrder => _totalOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['from_time'] = _fromTime;
    map['to_time'] = _toTime;
    map['last_order_time'] = _lastOrderTime;
    map['status'] = _status;
    map['limit'] = _limit;
    map['total_order'] = _totalOrder;
    return map;
  }

}