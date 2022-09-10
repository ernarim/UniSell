import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled1/ProductPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled1/Product.dart';
import 'package:untitled1/ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Firebase Database reference

  var refTestFirestore = FirebaseFirestore.instance.collection("products");
  var refProduct = FirebaseFirestore.instance.collection("products");
  var userId = FirebaseAuth.instance.currentUser?.uid;
  List<String> favIdList = <String>[];

  late var isFav = false;

  final productdata = {
    "product_name": "product eren",
    "product_price": "123",
    "product_description": "adadfasfa",
    "product_id": "",
  };


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var refUser = FirebaseFirestore.instance.collection("users").doc(userId);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                            )));
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
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.fromLTRB(15, 8, 5, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: const Center(
                    child: Text(
                      "City",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.fromLTRB(5, 8, 5, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: const Center(
                    child: Text(
                      "School",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 30,
                  margin: const EdgeInsets.fromLTRB(5, 8, 15, 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: const Center(
                    child: Text("Others", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 3,),
          Expanded(
            child: StreamBuilder(
                stream: refTestFirestore.snapshots(),
                builder: (context, AsyncSnapshot event) {
                    if (event.hasData) {
                    var productList = <Product>[];

                    var gelenProducts = event.data!.docs;

                    if (gelenProducts != null) {
                      gelenProducts.forEach((nesne) {
                        var gelenKategori = Product.fromFirestore(nesne);
                        productList.add(gelenKategori);
                      });
                    }

                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1,
                        ),
                        itemCount: productList.length,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 40),
                        itemBuilder: (context, indeks) {
                          return SizedBox(
                            height: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                              product: productList[indeks],
                                            )));
                              },
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.black.withOpacity(0.15),
                                  elevation: 0,
                                  margin: const EdgeInsets.all(6),
                                  child: Stack(children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: const AssetImage(
                                                      "assets/images/basys.jpg"),
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.black
                                                          .withOpacity(0.1),
                                                      BlendMode.darken))),
                                        )),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        height: 50,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          margin: EdgeInsets.zero,
                                          elevation: 0,
                                          color: Colors.black.withOpacity(0.45),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 3),
                                                  child: Text(
                                                    "${productList[indeks].productPrice}\$",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 0, 0, 4),
                                                  child: Text(
                                                    "${productList[indeks].productName}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                    ),
                                    Positioned(
                                        right: -2,
                                        top: -2,
                                        child: MaterialButton(
                                          height: 26.0,
                                          minWidth: 26.0,
                                          color: Colors.black,


                                          child: Icon(Icons.favorite_border_rounded, color: Colors.white, size: 18),
                                          splashColor: Colors.grey,
                                          shape: new CircleBorder(),
                                          onPressed: () => {
                                            refUser.get().then((value) {
                                              favIdList = value.data()!["user_favourites"];
                                            }),




                                            if(favIdList.contains(productList[indeks].productId)==false){
                                              favIdList.add(productList[indeks].productId),

                                            },

                                            print(favIdList),
                                            refUser.set( {"user_favourites" : favIdList}, SetOptions(merge: true)),



                                          },

                                        )

                                    )

                                  ])),
                            ),
                          );
                        });
                  } else {
                    return const Center();
                  }
                }),
          )
        ],
      ),
    );
  }
}
