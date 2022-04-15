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
import "../../../global/global.dart";

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key? key, 
    this.onAnswer,
    required this.questionCountdown,
    required this.answerSelected,
    required this.answerWrong,
    required this.answerCorrect,
    required this.questionData,
    required this.questionProgress,
    required this.gems,
    }) : super(key: key);

  final int questionCountdown;
  final int answerSelected;
  final bool answerWrong;
  final bool answerCorrect;
  final dynamic questionData;
  final double questionProgress;
  final int gems;

  final Function? onAnswer;

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  void handleAnswer(int index) {
    widget.onAnswer!(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QuestionGroup(),
        if(!isMobile(context)) const SizedBox(height: 24),
        AnswerGroup()
      ],
    );
  }

  //*QUESTION GROUP
  Widget QuestionGroup() {
    return Container(
      width: 640,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 12),
            blurRadius: 16
          )
        ]
      ),
      child: Column(
        children: [
          //*Control container
          Row( //*Information
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container( //*Gems icon
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        "assets/icons/gems.svg"
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.gems.toString(),
                      style: const TextStyle(
                        color: Color(0xBF000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 14
                      ),
                    )
                  ],
                )
              ),
              //*Time label
              AnimatedFlipCounter(
                duration: const Duration(milliseconds: 500),
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14
                ),
                value: widget.questionCountdown,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressBar(
            percentage: widget.questionProgress,
          ),

          //*QUESTION CONTAINER
          const SizedBox(height: 32),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.questionData["question"],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF414141)
                )
              )
            ],
          )
        ],
      ),
    );
  }

  //*ANSWER GROUP
  Widget AnswerGroup() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500
      ),
      child: 
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: widget.questionData["answers"].length,
        itemBuilder: (context, index) {
          var data = widget.questionData["answers"][index];

          return TextSelectBox(
            label: data, 
            onPressed: () {
              handleAnswer(index);
            },
            selected: widget.answerSelected == index,
            correct: widget.answerCorrect && widget.answerSelected == index,
            wrong: widget.answerWrong && widget.answerSelected == index || widget.answerWrong && widget.answerSelected == -1,
          );
        },
      )
    );
  }
}