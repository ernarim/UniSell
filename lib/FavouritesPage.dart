import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled1/Product.dart';
import 'package:untitled1/ProductPage.dart';
import 'package:untitled1/ProfilePage.dart';
import 'package:untitled1/UserClass.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}


class _FavouritesPageState extends State<FavouritesPage> {

  late List<String> favIdList = <String>[];
  late List<Product> favProducts = <Product>[];

  var userId = FirebaseAuth.instance.currentUser?.uid;
  late var refUser= FirebaseFirestore.instance.collection("users").doc(userId);
  var refProducts = FirebaseFirestore.instance.collection("products");

  Future<void> getFavIdList() async{
    final docSnap = await refUser.get();
    final user = UserClass.fromFirestore(docSnap);
    favIdList = user.userFavourites;
    print(favIdList);
  }

  Future<void> getFavProducts() async{
    await getFavIdList();
    refProducts.get().then((value) => {
      value.docs.forEach((element) {
        var product = Product.fromFirestore(element);
        if(favIdList.contains(product.productId)){
          favProducts.add(product);
        }
      }),
      print(favProducts),
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


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

          Expanded(
            child: FutureBuilder(

              future: getFavProducts(),
                builder: (context, AsyncSnapshot event) {
                    return ListView.builder(
                        itemCount: favProducts.length,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 40),
                        itemBuilder: (context, indeks) {
                          return SizedBox(
                            height: 90,
                            width: 350,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                          product: favProducts[indeks],
                                        )));
                              },
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                color: Colors.black.withOpacity(0.15),
                                elevation: 0,
                                margin: const EdgeInsets.all(6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Container(
                                        width: 75,
                                        height: 75,
                                        margin: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                            color: Colors.black,
                                            image: DecorationImage(image: const AssetImage("assets/images/basys.jpg"),
                                                fit: BoxFit.fill,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black
                                                      .withOpacity(0.45),
                                                  BlendMode.darken),
                                            ),
                                        )
                                      ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          "${favProducts[indeks].productName}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.start,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          "${favProducts[indeks].productPrice}\$",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(height: 8),


                                        Container(
                                          height: 20,
                                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.black),
                                          child: const Center(
                                            child: Text(
                                              "School", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 10))),
                                        ),

                                      ],
                                    ),
                                    Spacer(),
                                    MaterialButton(
                                      height: 24.0,
                                      minWidth: 24.0,
                                      color: Colors.black,
                                      child: Icon(Icons.remove, color: Colors.white, size: 18),
                                      splashColor: Colors.grey,
                                      shape: new CircleBorder(),
                                      onPressed: () =>{},
                                    )
                                  ],
                                ),
                              )
                            ),
                          );
                        });
                }),

          )


        ],
      )
    );
  }
}
