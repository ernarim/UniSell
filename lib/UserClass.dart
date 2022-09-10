import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  String userId;
  String userMail;
  String userPassword;
  String userName;
  String userSurname;
  String userPhoto;
  String userDescription;
  String userCity;
  String userSchool;
  List<String> userProducts;
  List<String> userFavourites;

  UserClass(
      this.userId,
      this.userMail,
      this.userPassword,
      this.userName,
      this.userSurname,
      this.userPhoto,
      this.userDescription,
      this.userCity,
      this.userSchool,
      this.userProducts,
      this.userFavourites
  );

  factory UserClass.fromJson(String key, Map<dynamic, dynamic> json) {
    return UserClass(
      key,
      json["user_mail"] as String,
      json["user_password"] as String,
      json["user_name"] as String,
      json["user_surname"] as String,
      json["user_photo"] as String,
      json["user_description"] as String,
      json["user_city"] as String,
      json["user_school"] as String,
      json["user_products"] as List<String>,
      json["user_favourites"] as List<String>
    );
  }

  factory UserClass.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserClass(
        data["user_id"] as String,
        data["user_mail"] as String,
        data["user_password"] as String,
        data["user_name"] as String,
        data["user_surname"] as String,
        data["user_photo"] as String,
        data["user_description"] as String,
        data["user_city"] as String,
        data["user_school"] as String,
        data["user_products"] as List<String>,
        List<String>.from(data["user_favourites"])
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "user_id": userId,
      if (userMail != null) "user_mail": userMail,
      if (userPassword != null) "user_password": userPassword,
      if (userName != null) "user_name": userName,
      if (userSurname != null) "user_surname": userSurname,
      if (userPhoto != null) "user_photo": userPhoto,
      if (userDescription != null) "user_description": userDescription,
      if (userCity != null) "user_city": userCity,
      if (userPhoto != null) "user_school": userPhoto,
      if (userProducts != null) "user_products": userProducts,
      if (userFavourites != null) "user_favourites": userFavourites,
    };
  }

}
