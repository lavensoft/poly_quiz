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
import "package:flutter_svg/svg.dart";
import "package:flutter/cupertino.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../../global/api.dart";

class GemsExchangeScreen extends StatefulWidget {
  GemsExchangeScreen({Key? key, required this.data}) : super(key: key);

  final Map<String,dynamic> data;

  @override
  _GemsExchangeScreenState createState() => _GemsExchangeScreenState();
}

class _GemsExchangeScreenState extends State<GemsExchangeScreen> {
  bool isLoading = true;
  bool isNotEnoughGems = false;
  int exchangedGems = 0;

  @override
  void initState() {
    super.initState();
    _exchangeGems();
  }

  //*Update gems
  void _exchangeGems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var gems = prefs.getInt("gems") ?? 0;
    List<String> values = widget.data["values"];

    Future.forEach(values, (element) async{
      var item = element.toString();

      if(isLoading) {
        if(item.indexOf("-") > -1) {
          int gemsFrom = int.parse(item.split("-")[0]);
          int gemsTo = int.parse(item.split("-")[1]);

          if(gems >= gemsFrom && gems <= gemsTo) {
            var newGems = gems - gemsFrom;

            await API.updateUserGems(newGems.toInt()).then((value) {
              prefs.setInt("gems", newGems.toInt());

              setState(() {
                isLoading = false;
                exchangedGems = gemsFrom;
              });
            });
          }
        }else if(gems >= int.parse(item)) {
          var newGems = gems - int.parse(item);

          await API.updateUserGems(newGems.toInt()).then((value) {
            prefs.setInt("gems", newGems.toInt());

            setState(() {
              isLoading = false;
              exchangedGems = int.parse(item);
            });
          });
        }else{
          setState(() {
            isNotEnoughGems = true;
            isLoading = false;
          });
        }
      }
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
                  isNotEnoughGems ? "Không thành công 🌨" : "Bạn đã đổi quà thành công  🎉 🎉" ,
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
                const SizedBox(height: 10),
                Text(
                  isNotEnoughGems ? "Bạn không đủ gems để nhận quà!" : "Bạn đã đổi $exchangedGems gems để nhận quà!",
                  style: const TextStyle(
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

                //*GEMS COUNT
                if(!isNotEnoughGems) UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                    margin: const EdgeInsets.fromLTRB(64, 24, 64, 24),
                    decoration: BoxDecoration(
                      color: const Color(0x45FFFFFF),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        Container( //*Gems icon
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            "assets/icons/gems.svg"
                          ),
                        ),

                        //*Gems count
                        const SizedBox(width: 12),
                        AnimatedFlipCounter(
                          //thousandSeparator: ".",
                          duration: const Duration(milliseconds: 2000),
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          value: -exchangedGems,
                        ),
                      ],
                    ),
                  )
                ),

                //*CONTINUE BTN
                const SizedBox(height: 40),
                PrimaryButton(
                  label: "Trở về trang chủ", 
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
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
                  "Mình đang đổi gems nè 😘",
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