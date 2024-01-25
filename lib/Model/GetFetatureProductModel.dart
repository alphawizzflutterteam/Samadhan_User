/// error : false
/// message : "Fetatures List successfully!"
/// data : [{"id":"4","name":"new product","product_id":"0","start_date":"2024-01-10","end_date":"2024-01-15","product_name":"Test","price":"100","description":"lorem ipsum ","product_image":"https://samadhaan.online/uploads/prescription/170497039555699.jpg","days_left":3},{"id":"5","name":"test product","product_id":"0","start_date":"2024-01-11","end_date":"2024-01-13","product_name":"test product","price":"100","description":"test product","product_image":"https://samadhaan.online/uploads/prescription/170497039555699.jpg","days_left":1}]
/// image_url : "https://entemarket.com/uploads/prescription/"

class GetFetatureProductModel {
  GetFetatureProductModel({
      bool? error, 
      String? message, 
      List<Data>? data, 
      String? imageUrl,}){
    _error = error;
    _message = message;
    _data = data;
    _imageUrl = imageUrl;
}

  GetFetatureProductModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _imageUrl = json['image_url'];
  }
  bool? _error;
  String? _message;
  List<Data>? _data;
  String? _imageUrl;
GetFetatureProductModel copyWith({  bool? error,
  String? message,
  List<Data>? data,
  String? imageUrl,
}) => GetFetatureProductModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
  imageUrl: imageUrl ?? _imageUrl,
);
  bool? get error => _error;
  String? get message => _message;
  List<Data>? get data => _data;
  String? get imageUrl => _imageUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['image_url'] = _imageUrl;
    return map;
  }

}

/// id : "4"
/// name : "new product"
/// product_id : "0"
/// start_date : "2024-01-10"
/// end_date : "2024-01-15"
/// product_name : "Test"
/// price : "100"
/// description : "lorem ipsum "
/// product_image : "https://samadhaan.online/uploads/prescription/170497039555699.jpg"
/// days_left : 3

class Data {
  Data({
      String? id, 
      String? name, 
      String? productId, 
      String? startDate, 
      String? endDate, 
      String? productName, 
      String? price, 
      String? description, 
      String? productImage, 
      num? daysLeft,}){
    _id = id;
    _name = name;
    _productId = productId;
    _startDate = startDate;
    _endDate = endDate;
    _productName = productName;
    _price = price;
    _description = description;
    _productImage = productImage;
    _daysLeft = daysLeft;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _productId = json['product_id'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _productName = json['product_name'];
    _price = json['price'];
    _description = json['description'];
    _productImage = json['product_image'];
    _daysLeft = json['days_left'];
  }
  String? _id;
  String? _name;
  String? _productId;
  String? _startDate;
  String? _endDate;
  String? _productName;
  String? _price;
  String? _description;
  String? _productImage;
  num? _daysLeft;
Data copyWith({  String? id,
  String? name,
  String? productId,
  String? startDate,
  String? endDate,
  String? productName,
  String? price,
  String? description,
  String? productImage,
  num? daysLeft,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
  productId: productId ?? _productId,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  productName: productName ?? _productName,
  price: price ?? _price,
  description: description ?? _description,
  productImage: productImage ?? _productImage,
  daysLeft: daysLeft ?? _daysLeft,
);
  String? get id => _id;
  String? get name => _name;
  String? get productId => _productId;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get productName => _productName;
  String? get price => _price;
  String? get description => _description;
  String? get productImage => _productImage;
  num? get daysLeft => _daysLeft;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['product_id'] = _productId;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['product_name'] = _productName;
    map['price'] = _price;
    map['description'] = _description;
    map['product_image'] = _productImage;
    map['days_left'] = _daysLeft;
    return map;
  }

}