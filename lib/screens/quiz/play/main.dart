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

import 'package:flutter/material.dart';
import 'package:quizz/lavenes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPlayScreen extends StatefulWidget {
  QuizPlayScreen({Key? key, 
    this.onPlay, 
    required this.title, 
    required this.subtitle, 
    required this.image, 
    required this.description,
    required this.quizId
  }) : super(key: key);

  final Function? onPlay;
  final String title;
  final String subtitle;
  final String image;
  final String description;
  final String quizId;

  @override
  _QuizPlayScreenState createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  bool joined = false;

  @override
  void initState() {
    super.initState();

    _verify();
  }

  Future<void> _verify() async {
    var prefs = await SharedPreferences.getInstance();
    String quizJoined = prefs.getString("quizJoined") ?? "";
    
    if(quizJoined.contains(widget.quizId)) {
      setState(() {
        joined = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(widget.image, width: 325,), //*BANNER IMAGE
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 325
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(//*SUB TITLE
                  widget.subtitle.toUpperCase(), 
                  style: const TextStyle( 
                    fontSize: 14,
                    color: Color(0xE6FFFFFF),
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 0),
                        blurRadius: 12,
                      ),
                    ]
                ),),
                const SizedBox(height: 10),
                Text(//*TITLE
                  joined ? "Bạn đã trả lời Quiz này!" : widget.title, 
                  style: const TextStyle(
                    fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Color(0x40000000),
                          offset: Offset(0, 0),
                          blurRadius: 12,
                        ),
                      ]
                    ),
                ),
                const SizedBox(height: 16),
                Text(//*DESCRIPTION
                  widget.description, 
                  style: const TextStyle( 
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Color(0x40000000),
                        offset: Offset(0, 0),
                        blurRadius: 12,
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 48),
        PrimaryButton( //*START BUTTON
          label: joined ? "Trở về trang chủ" : "Play",
          onPressed: () {
            if(joined){
              Navigator.pushReplacementNamed(context, "/home");
            }else{
              widget.onPlay!();
            }
          },
        )
      ],
    );
  }
}