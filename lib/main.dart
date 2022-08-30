import 'dart:collection';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/FavouritesPage.dart';
import 'package:untitled1/HomePage.dart';
import 'package:untitled1/MessagesPage.dart';
import 'package:untitled1/MyAdsPage.dart';

import 'PublishSalePage2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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

  // animation controllers
  late AnimationController _hideBottomBarAnimationController;

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

    // Animation Controllers
    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);
  }

  // Hide bottom navigation bar on scroll
  /*bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body:pageList[_bottomNavIndex],
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
        hideAnimationController: _hideBottomBarAnimationController,

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
