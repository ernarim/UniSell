import 'package:cloud_firestore/cloud_firestore.dart';

class MessageData {
  String chatId;
  List<dynamic> chatters;
  String productId;
  String productName;
  String sellerName;
  String sellerId;
  String buyerName;
  String buyerId;
  int timeInMillis;

  MessageData(
      this.chatId,
      this.chatters,
      this.productId,
      this.productName,
      this.sellerName,
      this.sellerId,
      this.buyerName,
      this.buyerId,
      this.timeInMillis);

  factory MessageData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageData(
        data["chatId"] as String,
        data["chatters"] as List<dynamic>,
        data["productId"] as String,
        data["productName"] as String,
        data["sellerName"] as String,
        data["sellerId"] as String,
        data["buyerName"] as String,
        data["buyerId"] as String,
        data["timeInMillis"] as int);
  }
}
