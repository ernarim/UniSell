import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:carousel_images/carousel_images.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:untitled1/HomePage.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:images_picker/images_picker.dart';


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

  @override
  Widget build(BuildContext context) {

    containerWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 20,
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
            Text("Title",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Container(
                padding: EdgeInsets.only(left: 10),
                height: 50,
                width: containerWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor("#D9D9D9"),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black))
            ),
            SizedBox(height: 12),

            Row(
              children: <Widget>[
                SizedBox(width: MediaQuery.of(context).size.width*(0.05)),
                Expanded(
                  child: Column(
                    children: [
                      Text("Category",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor("#D9D9D9"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*(0.03)),
                Expanded(
                  child: Column(
                    children: [
                      Text("School",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                      ),
                      SizedBox(height: 5),
                      Container(
                          alignment: Alignment.center,
                          height: 45,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: HexColor("#D9D9D9"),
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*(0.03)),
                Expanded(
                  child: Column(
                    children: [
                      Text("Price",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor("#D9D9D9"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*(0.05)),
              ],
            ),



            SizedBox(height: 12),
            Text("Photos",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Container(
              child: isImageAdded?
              CarouselSlider(
                  items: items,
                  options: CarouselOptions(
                    clipBehavior: Clip.none,
                    padEnds: false,
                    height: 250,
                    aspectRatio: 16 /9,
                    viewportFraction: 0.67,
                    initialPage: 0,
                    reverse: false,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: false  ,
                    scrollDirection: Axis.horizontal,
                  )
              ):
                  GestureDetector(
                    onTap: ()=> ImagesPicker.pick(
                        pickType: PickType.image,
                      count: 3
                      ),
                    child: Container(
                      height: 250,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color:HexColor("#D9D9D9"), width: 6 ),
                        borderRadius: BorderRadius.circular(10),
                        color: HexColor("#D9D9D9").withOpacity(0.5),
                      ),
                      child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Icon(Icons.add_a_photo_outlined, size: 32),
                                SizedBox(width: 5),
                                Icon(Icons.add_photo_alternate_outlined, size: 32)
                              ],),
                              SizedBox(height: 10),
                              Text("Click to add photo", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16))
                            ],
                          )

                    ),
                  )
            ),


            SizedBox(height: 12),
            Text("Details",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Container(
                height: 90,
                width: containerWidth,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor("#D9D9D9"),
                ),
                child: const TextField(
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),

            ),
            SizedBox(height: 15),
            Container(
                alignment: Alignment.center,
                height: 40,
                width: containerWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Text("Publish",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600))
            ),
            SizedBox(height: 12),

          ],
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.file, required this.deleteCallback})
      : super(key: key);

  final ImageFile file;
  final Function(ImageFile file) deleteCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: [
        Positioned.fill(
          child: !file.hasPath
              ? Image.memory(
                  file.bytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('No Preview'));
                  },
                )
              : Image.file(
                  File(file.path!),
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: InkWell(
            excludeFromSemantics: true,
            onLongPress: () {},
            child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 20,
                )),
            onTap: () {
              deleteCallback(file);
            },
          ),
        ),
      ],
    );
  }
}
