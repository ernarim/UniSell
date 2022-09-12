import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var universityController = TextEditingController();

  var usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor("#D9D9D9"),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Create Your Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.email_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              hintText: "Email",
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            scrollPadding: EdgeInsets.all(100),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              hintText: "Password",
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: nameController,
                            scrollPadding: EdgeInsets.all(100),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: HexColor("#D9D9D9"),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.short_text_rounded,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              hintText: "Name",
                              contentPadding: EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: TextFormField(
                      controller: universityController,
                      scrollPadding: EdgeInsets.all(100),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: HexColor("#D9D9D9"),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.apartment_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        hintText: "University",
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: Size.fromHeight(40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim());

                        final data = {
                          "name": nameController.text,
                          "university": universityController.text,
                          "email": emailController.text,
                        };

                        await usersCollection
                            .doc(userCredential.user?.uid)
                            .set(data)
                            .then(
                              (value) => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              ),
                            );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      "Create Account",
                      style: TextStyle(fontSize: 16, letterSpacing: 0.5 ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: TextStyle(color: Colors.black.withOpacity(0.5))),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
