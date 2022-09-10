import 'dart:collection';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/FavouritesPage.dart';
import 'package:untitled1/HomePage.dart';
import 'package:untitled1/MessagesPage.dart';
import 'package:untitled1/MyAdsPage.dart';

import 'PublishSalePage2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();

  var _bottomNavIndex = 0;

  var pageList = [
    const HomePage(),
    const FavouritesPage(),
    const MessagesPage(),
    const MyAdsPage()
  ];
  var textList = ["Home", "Favourites", "Messages", "My Ads"];

  bool fabState = false;

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.favorite_rounded,
    Icons.message_rounded,
    Icons.format_list_bulleted_rounded
  ];

  // Firebase database reference
  var refTest = FirebaseDatabase.instance.ref().child("products");

  @override
  void initState() {
    super.initState();

    // Firebase writing data
    var productNew = HashMap<String, dynamic>();
    productNew["product_id"] = "";
    productNew["product_name"] = "product eren";
    productNew["product_price"] = "130";
    productNew["product_description"] = "130";
    refTest.push().set(productNew);


    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pageList[_bottomNavIndex],
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PublishSalePage2()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.black : Colors.grey;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconList[index],
                size: 18,
                color: color,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: AutoSizeText(
                  textList[index],
                  maxLines: 1,
                  style: TextStyle(color: color),
                  group: autoSizeGroup,
                ),
              )
            ],
          );
        },

        // Bottom Navigation Bar Properties
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        backgroundColor: Colors.white,
        activeIndex: _bottomNavIndex,
        splashColor: Colors.white,
        splashSpeedInMilliseconds: 200,
        notchSmoothness: NotchSmoothness.softEdge,
        gapLocation: GapLocation.center,
        onTap: (index) => setState(() => _bottomNavIndex = index),

        shadow: const BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 1,
          color: Colors.grey,
        ),
      ),
    );
  }
}
