import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled1/chatDialogPage.dart';
import 'package:untitled1/messagesData.dart';

import 'Product.dart';

class ProductPage extends StatefulWidget {
  // Selected product data came from HomePage
  Product product;

  ProductPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  final double _panelHeightClosedRate = 0.21;
  final double _panelHeightOpenRate = 0.5;
  final double _panelStickWidthRate = 0.87;

  double _panelHeightClosed = 0;
  double _panelHeightOpen = 0;
  double _panelStickWidth = 0;

  List<Image> imageList = [
    Image.asset(
      'assets/images/basys.jpg',
      fit: BoxFit.fitWidth,
    ),
    Image.asset(
      'assets/images/eren.jpg',
      fit: BoxFit.fitWidth,
    ),
    Image.asset(
      'assets/images/eren.jpg',
      fit: BoxFit.fitWidth,
    ),
  ];

  late int pageLength = imageList.length;
  late int currentPageIndex = 0;

  var ownerName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var refUser = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.product.productOwnerId);
    refUser.get().then((value) {
      setState(() {
        ownerName = value.data()!["name"];
      });
      print(ownerName);
    });
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightClosed =
        MediaQuery.of(context).size.height * _panelHeightClosedRate;
    _panelHeightOpen =
        MediaQuery.of(context).size.height * _panelHeightOpenRate;
    _panelStickWidth = MediaQuery.of(context).size.width * _panelStickWidthRate;

    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    );

    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            SlidingUpPanel(
              backdropEnabled: true,
              panelBuilder: (sc) => _panel(sc),
              body: Center(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: () {
                      CustomImageProvider customImageProvider =
                          CustomImageProvider(
                              imageUrls: [
                                "assets/images/basys.jpg",
                                "assets/images/eren.jpg",
                                "assets/images/eren.jpg",
                              ].toList(),
                              initialIndex: currentPageIndex);
                      showImageViewerPager(context, customImageProvider,
                          onPageChanged: (page) {
                        print("Page changed to $page");
                      }, onViewerDismissed: (page) {});
                    },
                    child: ImageSlideshow(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height *
                          (1 - _panelHeightClosedRate + 0.03),
                      initialPage: currentPageIndex,
                      isLoop: true,
                      children: imageList, // List<Image>
                      onPageChanged: (value) {
                        print('Page changed: $value');
                        setState(() {
                          currentPageIndex = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              borderRadius: radius,
              parallaxEnabled: true,
              parallaxOffset: .5,
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5), blurRadius: 16.0)
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 15,
                margin: EdgeInsets.only(top: 15),
                padding: const EdgeInsets.only(left: 6, right: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
                  ],
                ),
                child: CarouselIndicator(
                  height: 5,
                  width: 15,
                  space: 3,
                  activeColor: Colors.black,
                  color: Colors.grey,
                  count: pageLength,
                  index: currentPageIndex,
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                height: 35,
                margin: const EdgeInsets.all(15),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: HexColor('#D9D9D9'),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 24.0,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        children: <Widget>[
          const SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text(
                    widget.product.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Text(
                    "${widget.product.productPrice}\$",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: _panelStickWidth,
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 13.0,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: const Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Text(
              widget.product.productDescription,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            ),
          ),
          const SizedBox(
            height: 13.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: _panelStickWidth,
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30),
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/images/basys.jpg'),
                      fit: BoxFit.fill),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, bottom: 4),
                    child: Text(ownerName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: _panelStickWidth,
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              SizedBox(width: 25),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: const Center(
                    child: Text(
                      "City",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      "School",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  child: Center(
                    child: Text(
                      widget.product.productCategories,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 25),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: _panelStickWidth,
                height: 1,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(20.0))),
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 20,
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.ios_share_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 60,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: TextField(
                            onTap: () async {
                              String buyerId =
                                  FirebaseAuth.instance.currentUser!.uid;
                              String buyerName;
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(buyerId)
                                  .get()
                                  .then(
                                (snapshot) {
                                  buyerName = snapshot.data()!["name"];
                                  final chatId = (buyerId.compareTo(widget
                                                  .product.productOwnerId) <
                                              0
                                          ? (buyerId +
                                              widget.product.productOwnerId)
                                          : (widget.product.productOwnerId +
                                              buyerId)) +
                                      widget.product.productId;
                                  final messageData = MessageData(
                                      chatId,
                                      <String>[
                                        buyerId,
                                        widget.product.productOwnerId
                                      ],
                                      widget.product.productId,
                                      widget.product.productName,
                                      widget.product.productOwnerName,
                                      widget.product.productOwnerId,
                                      buyerName,
                                      buyerId,
                                      0);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatDialogPage(messageData),
                                    ),
                                  );
                                },
                              );
                            },
                            keyboardType: TextInputType.text,
                            readOnly: true,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: "Send Message",
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.send_rounded,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border_rounded,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class CustomImageProvider extends EasyImageProvider {
  @override
  final int initialIndex;
  final List<String> imageUrls;

  CustomImageProvider({required this.imageUrls, this.initialIndex = 0})
      : super();

  @override
  ImageProvider<Object> imageBuilder(BuildContext context, int index) {
    return AssetImage(imageUrls[index]);
  }

  @override
  int get imageCount => imageUrls.length;
}
