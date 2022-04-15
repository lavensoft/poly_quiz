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
import 'package:flutter/rendering.dart';
import 'package:quizz/lavenes.dart';
import '../question/main.dart';

class QuizPlayScreen extends StatefulWidget {
  QuizPlayScreen({Key? key, 
    this.onPlay, 
    required this.title, 
    required this.subtitle, 
    required this.image, 
    required this.description}) : super(key: key);

  final Function? onPlay;
  final String title;
  final String subtitle;
  final String image;
  final String description;

  @override
  _QuizPlayScreenState createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
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
                Text(widget.subtitle.toUpperCase(), style: const TextStyle( //*SUB TITLE
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
                Text(widget.title, style: const TextStyle(//*TITLE
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
                Text(widget.description, style: const TextStyle( //*DESCRIPTION
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
          label: "Play",
          onPressed: () {
            widget.onPlay!();
          },
        )
      ],
    );
  }
}