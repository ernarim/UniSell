import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled1/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 35,
        ),
        Row(
          children: [
            GestureDetector(
              child: Container(
                height: 35,
                margin: const EdgeInsets.only(left: 15),
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
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Container(
              height: 35,
              margin: const EdgeInsets.only(right: 15),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: HexColor('#D9D9D9'),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mode_edit_outline_outlined,
                size: 24.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage('assets/images/basys.jpg'),
                    fit: BoxFit.fill),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "Name Surname",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20.0,
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(
              left: screenWidth * 0.07, right: screenWidth * 0.07),
          alignment: Alignment.centerLeft,
          child: Text(
            "About Me",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
        ),
        SizedBox(height: 7),
        Container(
          margin: EdgeInsets.only(
              left: screenWidth * 0.07, right: screenWidth * 0.07),
          alignment: Alignment.centerLeft,
          child: Text(
            "Bilkent ??niversitesinde Bilgisayar M??hendisli??i b??l??m??nde 2. s??n??f ????rencisiyim. Kullanmad??????m e??yalar??m?? sat??yorum dfsdfsdfdasf adsfsadfasdfsadfa",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
            color: Colors.black.withOpacity(0.2),
            height: 1,
            width: screenWidth * 0.88),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(
              left: screenWidth * 0.07, right: screenWidth * 0.07),
          alignment: Alignment.centerLeft,
          child: Text(
            "Information",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: screenWidth * 0.06),
            Icon(Icons.location_on_outlined),
            SizedBox(width: 5),
            Text(
              "Ankara, Turkey",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            )
          ],
        ),
        SizedBox(height: 3),
        Row(
          children: [
            SizedBox(width: screenWidth * 0.06),
            Icon(Icons.school_outlined),
            SizedBox(width: 5),
            Text(
              "Bilkent University",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Container(
            color: Colors.black.withOpacity(0.2),
            height: 1,
            width: screenWidth * 0.88),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                  left: screenWidth * 0.07, right: screenWidth * 0.02),
              alignment: Alignment.centerLeft,
              child: Text(
                "Products",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "See all",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: screenWidth * 0.07),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
            ),
          ],
        ),
        SizedBox(height: 8),
        ElevatedButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        (route) => false),
                  );
            },
            child: Text("Sign Out")),
      ]),
    );
  }
}
