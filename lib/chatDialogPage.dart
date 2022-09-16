import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/Product.dart';
import 'package:untitled1/ProductPage.dart';
import 'package:untitled1/messagesData.dart';

import 'Message.dart';

class ChatDialogPage extends StatefulWidget {
  final MessageData messageData;

  ChatDialogPage(this.messageData, {super.key});

  @override
  State<ChatDialogPage> createState() => _ChatDialogPageState();
}

class _ChatDialogPageState extends State<ChatDialogPage> {
  final chatsCollection = FirebaseFirestore.instance.collection("chats");
  late var chatDocument = chatsCollection.doc(widget.messageData.chatId);
  late var messagesCollection = chatDocument.collection("messages");
  var currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final productCollection = FirebaseFirestore.instance.collection("products");

  var controller = TextEditingController();
  var scrollCont = ScrollController();

  late Future<DocumentSnapshot<Map<String, dynamic>>> futureProduct;
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void initState() {
    super.initState();

    futureProduct = productCollection.doc(widget.messageData.productId).get();
    stream = messagesCollection.orderBy("time", descending: false).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentUserID == widget.messageData.sellerId
              ? widget.messageData.buyerName
              : widget.messageData.sellerName),
          backgroundColor: Colors.black26,
          actions: [
            Icon(Icons.more_vert),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: futureProduct,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  Product product = Product.fromFirestore(snapshot.data!);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.asset("assets/images/basys.jpg"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${product.productPrice} TL",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center();
                }
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasData && !asyncSnapshot.hasError) {
                    List<Message> message = [];
                    for (var doc in asyncSnapshot.data!.docs) {
                      message.add(Message.fromFirestore(doc));

                      if (currentUserID != message.last.senderId &&
                          !message.last.isSeen) {
                        doc.reference.update({"isSeen": true});
                      }
                    }
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      scrollCont.jumpTo(scrollCont.position.minScrollExtent);
                    });
                    return GroupedListView<Message, DateTime>(
                      controller: scrollCont,
                      reverse: true,
                      order: GroupedListOrder.DESC,
                      elements: message,
                      groupBy: (message) => DateTime(
                          message.date[0], message.date[1], message.date[2]),
                      groupHeaderBuilder: (Message message) => SizedBox(
                        height: 40,
                        child: Center(
                          child: Card(
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                DateFormat.yMMMd().format(message.dateTime),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      itemBuilder: (context, message) {
                        bool isCurrentUser = message.senderId ==
                            FirebaseAuth.instance.currentUser!.uid;
                        return Row(
                          mainAxisAlignment: isCurrentUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            isCurrentUser
                                ? Container(
                                    constraints: BoxConstraints(
                                        maxWidth: screenWidth * 0.84),
                                    margin: EdgeInsets.only(
                                        top: 3, bottom: 3, right: 3),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: HexColor("#EAEAEA"),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      //border: Border.all(color: Colors.black45),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          message.text,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateFormat('HH:mm')
                                                  .format(message.dateTime),
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            message.isSeen
                                                ? Icon(
                                                    Icons.done_all,
                                                    color: Colors.green,
                                                    size: 20,
                                                  )
                                                : Icon(
                                                    Icons.done,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    constraints: BoxConstraints(
                                        maxWidth: screenWidth * 0.84),
                                    margin: EdgeInsets.only(
                                        top: 3, bottom: 3, left: 4),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          message.text,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(message.dateTime),
                                          style:
                                              TextStyle(color: Colors.white60),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center();
                  }
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "Mesaj",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.black,
                      onPressed: () async {
                        String text = controller.text;
                        controller.text = "";
                        if (text.isNotEmpty) {
                          //FocusScope.of(context).unfocus();
                          DateTime now = DateTime.now();
                          Map<String, dynamic> data1 = {
                            "chatters": widget.messageData.chatters,
                            "timeInMillis": now.millisecondsSinceEpoch,
                            "chatId": widget.messageData.chatId,
                            "sellerName": widget.messageData.sellerName,
                            "sellerId": widget.messageData.sellerId,
                            "buyerName": widget.messageData.buyerName,
                            "buyerId": widget.messageData.buyerId,
                            "productId": widget.messageData.productId,
                            "productName": widget.messageData.productName,
                          };
                          Map<String, dynamic> data2 = {
                            "text": text,
                            "senderId": FirebaseAuth.instance.currentUser!.uid,
                            "receiverId": "8wjir3uzfVh3shiEABDZpaiKbmp2",
                            "isSeen": false,
                            "time": DateTime.now().millisecondsSinceEpoch,
                            "date": <int>[
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                              now.second
                            ],
                          };

                          await chatDocument.set(data1);
                          await messagesCollection.add(data2);
                        }
                      },
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
