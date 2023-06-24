/// error : false
/// message : "Delivery charges"
/// delivery_charge : 0

class DeliveryModel {
  DeliveryModel({
      bool? error, 
      String? message, 
      String? deliveryCharge,}){
    _error = error;
    _message = message;
    _deliveryCharge = deliveryCharge;
}

  DeliveryModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _deliveryCharge = json['delivery_charge'];
  }
  bool? _error;
  String? _message;
  String? _deliveryCharge;
DeliveryModel copyWith({  bool? error,
  String? message,
  String? deliveryCharge,
}) => DeliveryModel(  error: error ?? _error,
  message: message ?? _message,
  deliveryCharge: deliveryCharge ?? _deliveryCharge,
);
  bool? get error => _error;
  String? get message => _message;
  String? get deliveryCharge => _deliveryCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    map['delivery_charge'] = _deliveryCharge;
    return map;
  }

}