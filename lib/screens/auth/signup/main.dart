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

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String name = "";
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    
    // if(Global.storage.getItem("email") != null && Global.storage.getItem("name") != null && Global.storage.getItem("userId") != null) {
    //   Navigator.of(context).pushNamed("/");
    // }
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
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }

    Future<void> _handleSignup() async {
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

      if(name.isEmpty || email.isEmpty || password.isEmpty) {
        _handleShowAlert("🙈", "Vui lòng nhập đầy đủ thông tin!");
      }else if(!emailValid) {
        _handleShowAlert("🙈", "Email không hợp lệ!");
      }else if(email.split("@")[1] != "fpt.edu.vn") {
        _handleShowAlert("🙈", "Đây không phải là email của FPT!");
      }else{
        UserAPI.add(
          email,
          name,
          password
        ).then((value) async{
          if(value["code"] == 200) {
            var userData = value["data"];

            print(userData);

            final prefs = await SharedPreferences.getInstance();

            //Clear data
            prefs.remove("avatar");
            prefs.remove("name");
            prefs.remove("email");
            prefs.remove("gems");
            prefs.remove("userId");
            prefs.remove("companyId");

            //Set data
            prefs.setString("avatar", userData["avatar"]);
            prefs.setString("name", userData["name"]);
            prefs.setString("email", userData["email"]);
            prefs.setInt("gems", userData["data"]["gems"]);
            prefs.setString("userId", userData["_id"]);
            prefs.setString("companyId", userData["companyId"]);
            prefs.setString("token", userData["accessToken"]);

            Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
          }else{
            if(value["message"] == "USER_IS_ALREADY") {
              _handleShowAlert("✉️", "Email đã được sử dụng");
            }else {
              _handleShowAlert("⛔️", value["message"]);
            }
          }
        });
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
                    "Đăng Ký",
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Hãy đăng ký với gmail FPT nhé 😘",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),
                  TextBox(
                    placeholder: "Họ & Tên",
                    onChanged: (e) {
                      setState(() {
                        name = e;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextBox(
                    placeholder: "Email",
                    onChanged: (e) {
                      setState(() {
                        email = e;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextBox(
                    obscureText: true,
                    placeholder: "Mật khẩu",
                    onChanged: (e) {
                      setState(() {
                        password = e;
                      });
                    },
                  ),
                  const SizedBox(height: 48),
                  PrimaryButton(
                    label: "Đăng ký", 
                    onPressed: () {
                      _handleSignup();
                    }
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "Bạn đã có tài khoản?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Đăng nhập",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange
                            ),
                          ),
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}