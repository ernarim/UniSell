import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productId;
  String productName;
  String productPrice;
  String productDescription;
  String productOwnerId;
  String productOwnerName;
  String productCategories;

  Product(
    this.productId,
    this.productName,
    this.productPrice,
    this.productDescription,
    this.productOwnerId,
    this.productOwnerName,
    this.productCategories,
  );

  factory Product.fromJson(String key, Map<dynamic, dynamic> json) {
    return Product(
      key,
      json["product_name"] as String,
      json["product_price"] as String,
      json["product_description"] as String,
      json["product_owner_id"] as String,
      json["product_owner_name"] as String,
      json["product_categories"] as String,
    );
  }

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      data["product_id"],
      data["product_name"],
      data["product_price"],
      data["product_description"],
      data["product_owner_id"],
      data["product_owner_name"],
      data["product_categories"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (productId != null) "product_id": productId,
      if (productName != null) "product_name": productName,
      if (productPrice != null) "product_price": productPrice,
      if (productDescription != null) "product_description": productDescription,
      if (productOwnerId != null) "product_owner_id": productOwnerId,
      if (productCategories != null) "product_categories": productCategories,
    };
  }
}
