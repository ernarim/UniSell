import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled1/Product.dart';
import 'package:untitled1/ProductPage.dart';
import 'package:untitled1/ProfilePage.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({Key? key}) : super(key: key);

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {

  var userProductsIdList = <dynamic>[];

  var userId = FirebaseAuth.instance.currentUser?.uid;
  late var refUser = FirebaseFirestore.instance.collection("users").doc(userId);
  var refProducts = FirebaseFirestore.instance.collection("products");


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                flex: 20,
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.fromLTRB(15, 15, 10, 5),
                  decoration: BoxDecoration(
                    color: HexColor('#D9D9D9'),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_outlined,
                    size: 32.0,
                  ),
                ),
              ),
              Expanded(
                flex: 60,
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: HexColor("#D9D9D9")),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                          child: const Icon(
                            Icons.search_rounded,
                            size: 32,
                          )),
                      Text(
                        "Search...",
                        style: TextStyle(color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.fromLTRB(10, 15, 15, 5),
                    decoration: BoxDecoration(
                      color: HexColor('#D9D9D9'),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      size: 32.0,
                    ),
                  ),
                ),
              )
            ],
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: refUser.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                try {
                  userProductsIdList = snapshot.data?.get("user_products");
                } catch (e) {
                  return Expanded(
                    child: Center(
                      child: Text("You don't have any products yet"),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: userProductsIdList.length,
                    itemBuilder: (context, index) {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: refProducts
                            .doc(userProductsIdList[index] as String)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && !snapshot.hasError) {
                            var product = snapshot.data!;
                            return SizedBox(
                              height: 90,
                              width: 350,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        product: Product.fromFirestore(product),
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.black.withOpacity(0.15),
                                  elevation: 0,
                                  margin: const EdgeInsets.all(6),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 75,
                                          height: 75,
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            color: Colors.black,
                                            image: DecorationImage(
                                              image: const AssetImage(
                                                  "assets/images/basys.jpg"),
                                              fit: BoxFit.fill,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black
                                                      .withOpacity(0.45),
                                                  BlendMode.darken),
                                            ),
                                          )),
                                      SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          Text(
                                            product['product_name'],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            product["product_price"],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            height: 20,
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 0, 15, 0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(20),
                                                color: Colors.black),
                                            child: const Center(
                                                child: Text("School",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 10))),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      MaterialButton(
                                        height: 24.0,
                                        minWidth: 24.0,
                                        color: Colors.black,
                                        splashColor: Colors.grey,
                                        shape: CircleBorder(),
                                        onPressed: () => {
                                          userProductsIdList.remove(product["product_id"]),
                                          refUser.update ({"user_products" : userProductsIdList}),
                                          refProducts.doc(product["product_id"]).delete(),
                                          refUser.get().then((value) {
                                            List<dynamic> favIdList = value.data()!["user_favourites"];
                                            print(favIdList);
                                            favIdList.remove(product["product_id"]);
                                            refUser.update ({"user_favourites" : favIdList});
                                          })
                                        },
                                        child: Icon(Icons.delete_outline_rounded,
                                            color: Colors.white, size: 18),
                                      )
                                    ],
                                  ),
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
    );
  }
}
