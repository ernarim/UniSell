import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productId;
  String productName;
  String productPrice;
  String productDescription;
  String productPhotoPath;
  String productOwnerId;
  String productCategories;
  bool isFav;

  Product(
      this.productId,
      this.productName,
      this.productPrice,
      this.productDescription,
      this.productPhotoPath,
      this.productOwnerId,
      this.productCategories,
      this.isFav);

  factory Product.fromJson(String key, Map<dynamic, dynamic> json) {
    return Product(
        key,
        json["product_name"] as String,
        json["product_price"] as String,
        json["product_description"] as String,
        json["product_photo_path"] as String,
        json["product_owner_id"] as String,
        json["product_categories"] as String,
        json["is_fav"] as bool,
    );
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
        data["product_categories"] as String,
        data["is_fav"] as bool
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (productId != null) "product_id": productId,
      if (productName != null) "product_name": productName,
      if (productPrice != null) "product_price": productPrice,
      if (productDescription != null) "product_description": productDescription,
      if (productPhotoPath != null) "product_photo_path": productPhotoPath,
      if (productOwnerId != null) "product_owner_id": productOwnerId,
      if (productCategories != null) "product_categories": productCategories,
      if (isFav != null) "is_fav": isFav
    };
  }

}
