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
import "../../../global/global.dart";

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    
    checkLogin();
  }
  
  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString("email") != null && prefs.getString("name") != null && prefs.getString("userId") != null) {
      Navigator.of(context).pushNamedAndRemoveUntil("/", (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

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

    Future<void> _handleSignIn() async {
      final prefs = await SharedPreferences.getInstance();
      bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailController.text);

      if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _handleShowAlert("🙈", "Vui lòng nhập đầy đủ thông tin!");
      }else if(!emailValid) {
        _handleShowAlert("🙈", "Email không hợp lệ!");
      }else if(_emailController.text.split("@")[1] != "fpt.edu.vn") {
        _handleShowAlert("📬", "Đây không phải là email của FPT!");
      }else{
        API.authUser(_emailController.text, _passwordController.text).then((value) {
          if(value["code"] == 200) {
            var userData = value["data"];
            
            //Set data
            prefs.setString("avatar", userData["avatar"]);
            prefs.setString("name", userData["name"]);
            prefs.setString("email", userData["email"]);
            prefs.setInt("gems", userData["usrData"]["gems"]);
            prefs.setString("userId", userData["_id"]);
            prefs.setString("companyId", userData["companyId"]);
    
            Navigator.pushReplacementNamed(context, "/");
          }else{
            if(value["message"] == "PASSWORD_NOT_MATCH") {
              _handleShowAlert("🔒", "Mật khẩu không đúng!");
            }else if(value["message"] == "EMAIL_NOT_FOUND") {
              _handleShowAlert("💌", "Email không tồn tại!");
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
                  const SizedBox(height: 48),
                  TextBox(
                    hintText: "Email",
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  TextBox(
                    obscureText: true,
                    hintText: "Mật khẩu",
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 48),
                  PrimaryButton(
                    label: "Đăng nhập", 
                    onPressed: () {
                      _handleSignIn();
                    }
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "Bạn chưa có tài khoản?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            "Đăng ký",
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
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}