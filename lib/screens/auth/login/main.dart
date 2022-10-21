/*
 * COPYRIGHT (c) 2022 Lavenes.
 * COPYRIGHT (c) 2022 Nhats Devil.
 *
 * This document is the property of Lavenes.
 * It is considered confidential and proprietary.
 *
 * This document may not be reproduced or transmitted in any form,
 * in whole or in part, without the express written permission of
 * Lavenes.
 */

import "package:flutter/material.dart";
import "package:quizz/lavenes.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../../../api/main.dart";
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
  ],
);

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();

    checkLogin();
  }
  
  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString("email") != null && prefs.getString("name") != null && prefs.getString("userId") != null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {

    void _handleShowAlert (String title, String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }

    Future<void> _handleSignIn() async {
      try {
        await _googleSignIn.signIn().then((userData) async {
          final prefs = await SharedPreferences.getInstance();
          bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(userData?.email ?? "");

          if(!emailValid) {
            _handleShowAlert("🙈", "Email không hợp lệ!");
          }else if(userData?.email.split("@")[1] != "fpt.edu.vn") {
            _handleShowAlert("📬", "Đây không phải là email của FPT!");
          }else{
            var googleKey= await userData!.authentication;
            var accessToken = googleKey.accessToken;

            var loginRes = await UserAPI.authGoogle(accessToken);

            if(loginRes["code"] == 200) {
              var userData = loginRes["data"];
        
              prefs.setString("avatar", "");
              prefs.setString("name", userData["name"]);
              prefs.setString("email", userData["email"]);
              prefs.setInt("gems", userData["moreData"]?["gems"] ?? 0);
              prefs.setString("userId", userData["_id"]);
              prefs.setString("companyId", userData["app"] ?? userData["companyId"]);
              prefs.setString("token", userData["accessToken"]);
      
              Navigator.pushReplacementNamed(context, "/home");
            }else{
              _handleShowAlert("🙈", "Đăng nhập thất bại");
            }
          }
        });
      } catch (error) {
        _handleShowAlert("🛑", error.toString());
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Container( 
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Poly Quiz",
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Hãy đăng nhập với gmail FPT nhé 😘",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // const SizedBox(height: 48),
                  // TextBox(
                  //   placeholder: "Email",
                  //   onChanged: (e) {
                  //     setState(() {
                  //       email = e;
                  //     });
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  // TextBox(
                  //   obscureText: true,
                  //   placeholder: "Mật khẩu",
                  //   onChanged: (e) {
                  //     setState(() {
                  //       password = e;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 48),
                  PrimaryButton(
                    label: "Đăng nhập với Google", 
                    onPressed: () {
                      _handleSignIn();
                    }
                  ),
                  // const SizedBox(height: 32),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, "/signup");
                  //   },
                  //   child: Container(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: const [
                  //         Text(
                  //           "Bạn chưa có tài khoản?",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.black45
                  //           ),
                  //         ),
                  //         SizedBox(width: 3),
                  //         Text(
                  //           "Đăng ký",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize: 13,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.orange
                            // ),
                          // ),
                        // ],
                      // ),
                    // )
                  // ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}