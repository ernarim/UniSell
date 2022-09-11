import 'dart:collection';
import 'dart:html';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:images_picker/images_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:untitled1/MyHomePage.dart';
import 'package:untitled1/storage_service.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishSalePage extends StatefulWidget {
  const PublishSalePage({Key? key}) : super(key: key);

  @override
  State<PublishSalePage> createState() => _PublishSalePageState();
}

class _PublishSalePageState extends State<PublishSalePage> {
  final List<Widget> items = [
    Image(image: AssetImage("assets/images/basys.jpg")),
    Image(image: AssetImage("assets/images/eren.jpg")),
    Image(image: AssetImage("assets/images/basys.jpg")),
    Image(image: AssetImage("assets/images/basys.jpg"))
  ];
  late double containerWidth;
  bool isImageAdded = false;


  final minTitleChars = 6;

  List<AssetEntity>? result = [];
  late int resultLength = result!.length;
  String value = "";

  var titleController = TextEditingController();
  var categoryController = TextEditingController();
  var priceController = TextEditingController();
  var conditionController = TextEditingController();
  var detailsController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var categoryList = <String>["Book", "Electronics", "Other"];
  String? selectedCategory;

  var conditionList = <String>["New", "Almost New", "Good", "Fine", "Worn-out"];
  String? selectedCondition;

  bool noPhoto = false;

  var userId = FirebaseAuth.instance.currentUser?.uid;
  late var refUser = FirebaseFirestore.instance.collection("users").doc(userId);
  var refProducts = FirebaseFirestore.instance.collection("products");
  var userProductsIdList = <dynamic>[];
  var publishedProductId;

  Future<void> getUserProductsIdList() async{
    refUser.get().then((value) {
      if(value.data()!["user_products"]!=null){
        userProductsIdList = value.data()!["user_products"];
      }
      print(userProductsIdList);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserProductsIdList();
  }

  @override
  Widget build(BuildContext context) {
    containerWidth = MediaQuery.of(context).size.width * 0.9;
    final StorageService storage = StorageService();

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                flex: 20,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(
                        context);
                  },
                  child: Container(
                    height: 35,
                    margin: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                    decoration: BoxDecoration(
                      color: HexColor('#D9D9D9'),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 60,
                child: Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.center,
                    child: Text("Publish Sale",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              ),
              Expanded(
                flex: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor('#D9D9D9'),
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
          Divider(thickness: 1),
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Title",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 5),
                  Container(
                      padding: EdgeInsets.only(left: 10, bottom: 3),
                      height: 50,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor("#D9D9D9"),
                      ),
                      child: TextFormField(
                        controller: titleController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            errorStyle: TextStyle(fontSize: 11, height: 1),
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.text,
                          style: TextStyle(color: Colors.black),
                          validator: (textInput) {
                            if (textInput != null) {
                              if (textInput.isEmpty) {
                                return "Please enter a title";
                              }
                              if (textInput.length < minTitleChars) {
                                return "Your title should have at least $minTitleChars characters";
                              }
                              return null;
                            }
                            return "Invalid Input";
                            },
                      )
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      SizedBox(width: MediaQuery.of(context).size.width * (0.05)),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Category",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            Container(
                                padding: EdgeInsets.only(left: 10, bottom: 3),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#D9D9D9"),
                              ),
                              child: TextFormField(
                                controller: categoryController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    errorStyle: TextStyle(fontSize: 11, height: 1),
                                    border: InputBorder.none,
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WillPopScope(
                                          onWillPop: () async {
                                            FocusScope.of(context).unfocus();
                                            return true;
                                          },
                                          child: AlertDialog(
                                            titlePadding: EdgeInsets.all(0),
                                            contentPadding: EdgeInsets.all(0),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20,
                                                top: 20,
                                              ),
                                              child: Text("Select Category"),
                                            ),
                                            content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      categoryController.text =
                                                      "Books";
                                                      Navigator.pop(context);
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: Align(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                          child: Text(
                                                            "Books",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black45,
                                                                fontSize: 18),
                                                          ),
                                                        )),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      categoryController.text =
                                                      "Electronic Devices";
                                                      Navigator.pop(context);
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: Align(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                          child: Text(
                                                            "Electronic Devices",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black45,
                                                                fontSize: 18),
                                                          ),
                                                        )),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      categoryController.text =
                                                      "Other";
                                                      Navigator.pop(context);
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                    child: Align(
                                                        alignment:
                                                        Alignment.centerLeft,
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                          child: Text(
                                                            "Other",
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black45,
                                                                fontSize: 18),
                                                          ),
                                                        )),
                                                  )
                                                ]),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                validator: (categorySelection) {
                                  if (categorySelection != null) {
                                    if (categorySelection.isEmpty) {
                                      return "Please select a category";
                                    }
                                    return null;
                                  }
                                  return "Invalid Input";
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (0.03)),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Price",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 5, bottom: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: HexColor("#D9D9D9"),
                                ),
                              child: TextFormField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(0),
                                    errorStyle: TextStyle(fontSize: 11, height: 1),
                                    suffixText: "TL",
                                    border: InputBorder.none
                                ),

                                validator: (textInput) {
                                  if (textInput != null) {
                                    if (textInput.isEmpty) {
                                      return "Please set a price";
                                    }
                                    return null;
                                  }
                                  return "Invalid Input";
                                },
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (0.03)),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Condition",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 3),
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor("#D9D9D9"),
                              ),
                              child: TextFormField(
                                style: TextStyle(fontSize: 15),
                                controller: conditionController,
                                scrollPadding: EdgeInsets.all(100),
                                readOnly: true,
                                showCursor: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  errorStyle: TextStyle(fontSize: 11, height: 1),
                                    border: InputBorder.none,
                                    ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return WillPopScope(
                                        onWillPop: () async {
                                          FocusScope.of(context).unfocus();
                                          return true;
                                        },
                                        child: AlertDialog(
                                          titlePadding: EdgeInsets.all(0),
                                          contentPadding: EdgeInsets.all(0),
                                          title: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 20,
                                            ),
                                            child: Text("Condition of Product"),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  conditionController.text = "New";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(20),
                                                      child: Text(
                                                        "New",
                                                        style: TextStyle(
                                                            color: Colors.black45,
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  conditionController.text =
                                                  "Almost New";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(20),
                                                      child: Text(
                                                        "Almost New",
                                                        style: TextStyle(
                                                            color: Colors.black45,
                                                            fontSize: 18),
                                                      ),
                                                    )),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  conditionController.text = "Good";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(20),
                                                    child: Text(
                                                      "Good",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  conditionController.text =
                                                  "Not Bad";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(20),
                                                    child: Text(
                                                      "Not Bad",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  conditionController.text =
                                                  "Worn Out";
                                                  Navigator.pop(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size.zero,
                                                  padding: EdgeInsets.zero,
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(20),
                                                    child: Text(
                                                      "Worn Out",
                                                      style: TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                FocusScope.of(context).unfocus();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                validator: (textInput) {
                                  if (textInput != null) {
                                    if (textInput.isEmpty) {
                                      return "Please select a condition for your product";
                                    }
                                    return null;
                                  }
                                  return "Invalid Input";
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * (0.05)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text("Photos  $resultLength/5",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),

                  SizedBox(height: 5),
                  Container(
                    height: 120,
                    margin: EdgeInsets.only(left: 15, bottom: 0, right: 15),
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Card(
                          color: HexColor('#D9D9D9'),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                          child: SizedBox(
                            width: 120,
                            child: insideCard(resultLength, index),
                          ),
                        );
                      },
                    ),
                  ),
                  noPhoto
                      ? Text("Add at least one photo",
                      style: TextStyle(color: Colors.red, fontSize: 12))
                      : Text("", style: TextStyle(fontSize: 12),),
                  SizedBox(height: 5),
                  Text("Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 5),
                  Container(
                    height: 80,
                    width: containerWidth,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor("#D9D9D9"),
                    ),
                    child: TextFormField(
                      controller: detailsController,
                      maxLength: 1000,
                      minLines: 2,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          errorStyle: TextStyle(fontSize: 11, height: 1),
                          border: InputBorder.none),
                      validator: (textInput) {
                        if (textInput != null) {
                          if (textInput.isEmpty ||
                              textInput.length < 10) {
                            return "Need to be at least 10 characters";
                          }
                          return null;
                        }
                        return "Invalid Input";
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.only(right: 15, left: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40))),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                bool? validate = formKey.currentState?.validate();
                if (resultLength == 0 && !noPhoto) {
                  setState(() {
                    noPhoto = true;
                  });
                } else if (resultLength != 0 && noPhoto) {
                  setState(() {
                    noPhoto = false;
                  });
                }
                if (validate! && !noPhoto) {
                  Navigator.pop(context);

                  print(categoryController.text);
                  print(titleController.text);
                  print(priceController.text);
                  print(conditionController.text);
                  print(detailsController.text);

                  var productNew = HashMap<String, dynamic>();
                  productNew["product_id"] = "";
                  productNew["product_name"] = titleController.text;
                  productNew["product_price"] = priceController.text;
                  productNew["product_description"] = detailsController.text;
                  productNew["product_owner_id"] = refUser.id;
                  productNew["product_categories"] = categoryController.text;

                  var storageRef;
                  refProducts.add(productNew).then((value) => {
                    refProducts.doc(value.id).update({"product_id" : value.id}),
                    userProductsIdList.add(value.id),
                    refUser.update({"user_products" : userProductsIdList}),
                    storageRef = FirebaseStorage.instance.ref().child("product_images").child(value.id),
                    for(var i=0; i< result!.length; i++){
                        storageRef.putFile(Image(image: AssetEntityImageProvider(result![i])))
                    }
                  });

                }


              },
              child: Text(
                "Publish",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget? insideCard(int length, int index) {
    if (index < length) {
      return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Image(
                    image: AssetEntityImageProvider(result![index]),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          result!.removeAt(index);
                          resultLength--;
                        });
                      },
                      child: Text(
                        "Remove",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  ],
                );
              });
        },
        child: Image(
          image: AssetEntityImageProvider(result![index]),
          fit: BoxFit.cover,
        ),
      );
    } else if (index == length) {
      return GestureDetector(
        onTap: () async {
          List<AssetEntity>? result1 = await AssetPicker.pickAssets(
            context,
            pickerConfig: AssetPickerConfig(
              themeColor: Colors.black,
                maxAssets: 5 - resultLength,
                textDelegate: EnglishAssetPickerTextDelegate()),
          );
          setState(() {
            result = result! + result1!;
            resultLength = result!.length;
            if (resultLength != 0) {
              noPhoto = false;
            }
            print(result1);
          });
        },
        child: Center(
            child: Icon(
              Icons.add,
              size: 40,
            )),
      );
    } else {
      return null;
    }
  }

}
