import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/chatDialogPage.dart';
import 'package:untitled1/messagesData.dart';

import 'Message.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final currentUserID = FirebaseAuth.instance.currentUser!.uid;
  final chatsCollection = FirebaseFirestore.instance.collection("chats");

  late final Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream;

  @override
  void initState() {
    super.initState();
    chatsStream = chatsCollection
        .where("chatters", arrayContains: currentUserID)
        .orderBy("timeInMillis")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("Messages"),
            Divider(
              thickness: 2,
              height: 0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: chatsStream,
              builder: (context, snapshot) {
                var chatList = <MessageData>[];
                if (snapshot.hasData && !snapshot.hasError) {
                  for (var doc in snapshot.data!.docs) {
                    chatList.add(MessageData.fromFirestore(doc));
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        var messagesStream = chatsCollection
                            .doc(chatList[index].chatId)
                            .collection("messages")
                            .orderBy("time", descending: true)
                            .limit(1)
                            .snapshots();
                        final screenWidth = MediaQuery.of(context).size.width;
                        return StreamBuilder<QuerySnapshot>(
                          stream: messagesStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && !snapshot.hasError) {
                              var lastMessage = Message.fromFirestore(
                                  snapshot.data!.docs.first);
                              List<dynamic> lastMessageDate = lastMessage.date;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDialogPage(chatList[index]),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 105,
                                        width: 105,
                                        child: Card(
                                          shape: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                          child: Image.asset(
                                              "assets/images/basys.jpg"),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Container(
                                        height: 105,
                                        width: screenWidth * 0.50,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentUserID ==
                                                      chatList[index].sellerId
                                                  ? chatList[index].buyerName
                                                  : chatList[index].sellerName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              chatList[index].productName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                checkMark(lastMessage.senderId,
                                                    lastMessage.isSeen),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    lastMessage.text,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        height: 105,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              lastMessage.dateTime ==
                                                      DateTime.now()
                                                  ? "Today"
                                                  : DateFormat('dd.MM.yyyy')
                                                      .format(
                                                          lastMessage.dateTime),
                                            ),
                                            currentUserID ==
                                                        lastMessage
                                                            .receiverId &&
                                                    !lastMessage.isSeen
                                                ? Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                : Center(),
                                            Center(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text(snapshot.error.toString());
                            }
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return Container(
                    margin: EdgeInsets.all(7.0),
                    height: 10,
                    child: LinearProgressIndicator(
                      color: Colors.black45,
                      backgroundColor: Colors.grey,
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget checkMark(String senderId, bool isSeen) {
    if (senderId == currentUserID) {
      return isSeen
          ? Icon(
              Icons.done_all,
              color: Colors.green,
              size: 20,
            )
          : Icon(
              Icons.done,
              color: Colors.grey,
              size: 20,
            );
    } else {
      return Text("");
    }
  }
}
