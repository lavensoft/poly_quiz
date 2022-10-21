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
import "package:flutter/cupertino.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../../api/main.dart";

class CheckinScreen extends StatefulWidget {
  CheckinScreen({Key? key, required this.data}) : super(key: key);

  final Map<String,dynamic> data;

  @override
  _CheckinScreenState createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  bool isLoading = true;
  bool isCheckined = false;

  @override
  void initState() {
    super.initState();
    _checkinEvent();
  }

  //*Update gems
  void _checkinEvent() async {
    var res = await EventAPI.checkin(widget.data["event"]);

    if(res["code"] != 200) {
      setState(() {
        isCheckined = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(left: 48, right: 48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4ce9f5),
              Color(0xFF55e9f6),
              Color(0xFF08acf8),
            ],
          )
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 720
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: !isLoading ? [
                //* TITLE
                Text(
                  isCheckined ? "Bạn đã từng checkin rồi 🌨" : "Bạn đã checkin thành công  🎉 🎉" ,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        blurRadius: 12,
                        offset: Offset(0, 0),
                      )
                    ]
                  ),
                ),

                //*CONTINUE BTN
                const SizedBox(height: 40),
                PrimaryButton(
                  label: "Trở về trang chủ", 
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                  }
                ) 
              ] : [
                //*LOADING
                const CupertinoActivityIndicator(
                  animating: true,
                  radius: 14,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Mình đang checkin nè 😘",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        blurRadius: 12,
                        offset: Offset(0, 0),
                      )
                    ]
                  ),
                ),
              ],  
            )
          )
        )
      )
    );
  }
}