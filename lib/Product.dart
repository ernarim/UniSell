import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productId;
  String productName;
  String productPrice;
  String productDescription;
  String productPhotoPath;
  String productOwnerId;
  List<String> productCategories;

  Product(
      this.productId,
      this.productName,
      this.productPrice,
      this.productDescription,
      this.productPhotoPath,
      this.productOwnerId,
      this.productCategories);

  factory Product.fromJson(String key, Map<dynamic, dynamic> json) {
    return Product(
        key,
        json["product_name"] as String,
        json["product_price"] as String,
        json["product_description"] as String,
        json["product_photo_path"] as String,
        json["product_owner_id"] as String,
        json["product_categories"] as List<String>);
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
        data["product_id"] as String,
        data["product_name"] as String,
        data["product_price"] as String,
        data["product_description"] as String,
        data["product_photo_path"] as String,
        data["product_owner_id"] as String,
        data["product_categories"] as List<String>);
  }
}
