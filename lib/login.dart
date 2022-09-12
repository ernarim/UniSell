import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled1/MyHomePage.dart';
import 'package:untitled1/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor("#D9D9D9"),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Login To Your Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                        SizedBox(
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
                      ],
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
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim())
                            .then((value) =>
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MyHomePage(),
                                    ),
                                    (route) => false));
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      "Sign in",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.black.withOpacity(0.5))),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
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
    );
  }
}
