import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text;
  String senderId;
  String receiverId;
  bool isSeen;
  int time;
  List<dynamic> date;
  DateTime dateTime;

  Message(this.text, this.senderId, this.receiverId, this.isSeen, this.time,
      this.date, this.dateTime);

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final x = data["date"] as List<dynamic>;
    return Message(
        data["text"] as String,
        data["senderId"] as String,
        data["receiverId"] as String,
        data["isSeen"] as bool,
        data["time"] as int,
        x,
        DateTime(x[0], x[1], x[2], x[3], x[4]));
  }
}
