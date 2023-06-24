class FeatureProductModel {
  FeatureProductModel({
    required this.id,
    required this.name,
    required this.productId,
    required this.startDate,
    required this.endDate,
    required this.productName,
    required this.price,
    required this.description,
    required this.productImage,
  });
  late final String id;
  late final String name;
  late final String productId;
  late final String startDate;
  late final String endDate;
  late final String productName;
  late final String price;
  late final String description;
  late final String productImage;

  FeatureProductModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    productId = json['product_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    productName = json['product_name'];
    price = json['price'];
    description = json['description'];
    productImage = json['product_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['product_id'] = productId;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['product_name'] = productName;
    _data['price'] = price;
    _data['description'] = description;
    _data['product_image'] = productImage;
    return _data;
  }
}
class FeatureOrderModel {
  FeatureOrderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.description,
    required this.phone,
    required this.productId,
    required this.createdAt,
    required this.userId,
    required this.qty,
    required this.startDate,
    required this.endDate,
    required this.productName,
    required this.price,
    required this.productImage,
    required this.total_amount,
  });
  late final String id;
  late final String name;
  late final String email;
  late final String description;
  late final String phone;
  late final String productId;
  late final String createdAt;
  late final String userId;
  late final String qty;
  late final String startDate;
  late final String endDate;
  late final String productName;
  late final String price;
  late final String productImage;
  late final String total_amount;
  FeatureOrderModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    description = json['description'];
    phone = json['phone'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    userId = json['user_id'];
    qty = json['qty'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    productName = json['product_name'];
    price = json['price'];
    productImage = json['product_image'];
    total_amount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['description'] = description;
    _data['phone'] = phone;
    _data['product_id'] = productId;
    _data['created_at'] = createdAt;
    _data['user_id'] = userId;
    _data['qty'] = qty;
    _data['start_date'] = startDate;
    _data['end_date'] = endDate;
    _data['product_name'] = productName;
    _data['price'] = price;
    _data['product_image'] = productImage;
    return _data;
  }
}