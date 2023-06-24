import 'dart:convert';
/// error : false
/// message : "Get society!"
/// data : [{"id":"5","name":"Vasant Sagar Krishna Kaveri CHS Ltd","city_id":"8","zipcode_id":"9","minimum_free_delivery_order_amount":"100","delivery_charges":"10","weight":"5"},{"id":"6","name":"Vasant Sagar Yamuna CHS LTD","city_id":"8","zipcode_id":"9","minimum_free_delivery_order_amount":"100","delivery_charges":"10","weight":"5"},{"id":"7","name":"Vasant Sagar Ganga CHS LTD","city_id":"8","zipcode_id":"9","minimum_free_delivery_order_amount":"100","delivery_charges":"10","weight":"5"},{"id":"8","name":"Vasant Sagar Saraswati CHS LTD","city_id":"8","zipcode_id":"9","minimum_free_delivery_order_amount":"100","delivery_charges":"10","weight":"5"}]

GetSocityMOdel getSocityMOdelFromJson(String str) => GetSocityMOdel.fromJson(json.decode(str));
String getSocityMOdelToJson(GetSocityMOdel data) => json.encode(data.toJson());
class GetSocityMOdel {
  GetSocityMOdel({
      bool? error, 
      String? message, 
      List<Data>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  GetSocityMOdel.fromJson(dynamic json) {
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
GetSocityMOdel copyWith({  bool? error,
  String? message,
  List<Data>? data,
}) => GetSocityMOdel(  error: error ?? _error,
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

/// id : "5"
/// name : "Vasant Sagar Krishna Kaveri CHS Ltd"
/// city_id : "8"
/// zipcode_id : "9"
/// minimum_free_delivery_order_amount : "100"
/// delivery_charges : "10"
/// weight : "5"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? name, 
      String? cityId, 
      String? zipcodeId, 
      String? minimumFreeDeliveryOrderAmount, 
      String? deliveryCharges, 
      String? weight,}){
    _id = id;
    _name = name;
    _cityId = cityId;
    _zipcodeId = zipcodeId;
    _minimumFreeDeliveryOrderAmount = minimumFreeDeliveryOrderAmount;
    _deliveryCharges = deliveryCharges;
    _weight = weight;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _cityId = json['city_id'];
    _zipcodeId = json['zipcode_id'];
    _minimumFreeDeliveryOrderAmount = json['minimum_free_delivery_order_amount'];
    _deliveryCharges = json['delivery_charges'];
    _weight = json['weight'];
  }
  String? _id;
  String? _name;
  String? _cityId;
  String? _zipcodeId;
  String? _minimumFreeDeliveryOrderAmount;
  String? _deliveryCharges;
  String? _weight;
Data copyWith({  String? id,
  String? name,
  String? cityId,
  String? zipcodeId,
  String? minimumFreeDeliveryOrderAmount,
  String? deliveryCharges,
  String? weight,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  cityId: cityId ?? _cityId,
  zipcodeId: zipcodeId ?? _zipcodeId,
  minimumFreeDeliveryOrderAmount: minimumFreeDeliveryOrderAmount ?? _minimumFreeDeliveryOrderAmount,
  deliveryCharges: deliveryCharges ?? _deliveryCharges,
  weight: weight ?? _weight,
);
  String? get id => _id;
  String? get name => _name;
  String? get cityId => _cityId;
  String? get zipcodeId => _zipcodeId;
  String? get minimumFreeDeliveryOrderAmount => _minimumFreeDeliveryOrderAmount;
  String? get deliveryCharges => _deliveryCharges;
  String? get weight => _weight;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['city_id'] = _cityId;
    map['zipcode_id'] = _zipcodeId;
    map['minimum_free_delivery_order_amount'] = _minimumFreeDeliveryOrderAmount;
    map['delivery_charges'] = _deliveryCharges;
    map['weight'] = _weight;
    return map;
  }

}