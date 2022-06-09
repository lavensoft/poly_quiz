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
    required this.countTime,
    this.showGems = true,
    this.showProgress = true,
    }) : super(key: key);

  final int questionCountdown;
  final int countTime;
  final int answerSelected;
  final bool answerWrong;
  final bool answerCorrect;
  final bool showGems;
  final bool showProgress;
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
        !isMobile(context) ? const SizedBox(height: 24) : const SizedBox(height: 40),
        AnswerGroup()
      ],
    );
  }

  //*QUESTION GROUP
  Widget QuestionGroup() {
    print(widget.questionData);
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
              (widget.questionData["showGems"]) ? Expanded(
                child: Row(
                  children: [
                    Container( //*Gems icon
                      width: 24,
                      height: 24,
                      child: Image.asset(
                        "assets/icons/gems.png"
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
              ) : Container(),
              //*Time label
              if(widget.countTime > -1) AnimatedFlipCounter(
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
          if(widget.showProgress) const SizedBox(height: 16),
          if(widget.showProgress) ProgressBar(
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
    bool isEmoji = widget.questionData["isEmoji"] ?? false;
    
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500
      ),
      child: isEmoji ?
      Wrap(
        spacing: 5,
        children: [
          TextSelectBox(
            label: "☹", 
            isEmoji: isEmoji,
            onPressed: () {
              handleAnswer(0);
            },
            selected: widget.answerSelected == 0,
            correct: widget.answerCorrect && widget.answerSelected == 0,
            wrong: widget.answerWrong && widget.answerSelected == 0 || widget.answerWrong && widget.answerSelected == -1,
          ),
          TextSelectBox(
            label: "😐", 
            isEmoji: isEmoji,
            onPressed: () {
              handleAnswer(1);
            },
            selected: widget.answerSelected == 1,
            correct: widget.answerCorrect && widget.answerSelected == 1,
            wrong: widget.answerWrong && widget.answerSelected == 1 || widget.answerWrong && widget.answerSelected == -1,
          ),
          TextSelectBox(
            label: "🙂", 
            isEmoji: isEmoji,
            onPressed: () {
              handleAnswer(2);
            },
            selected: widget.answerSelected == 2,
            correct: widget.answerCorrect && widget.answerSelected == 2,
            wrong: widget.answerWrong && widget.answerSelected == 2 || widget.answerWrong && widget.answerSelected == -1,
          ),
          TextSelectBox(
            label: "😀", 
            isEmoji: isEmoji,
            onPressed: () {
              handleAnswer(3);
            },
            selected: widget.answerSelected == 3,
            correct: widget.answerCorrect && widget.answerSelected == 3,
            wrong: widget.answerWrong && widget.answerSelected == 1 || widget.answerWrong && widget.answerSelected == -1,
          ),
          TextSelectBox(
            label: "🥰", 
            isEmoji: isEmoji,
            onPressed: () {
              handleAnswer(4);
            },
            selected: widget.answerSelected == 4,
            correct: widget.answerCorrect && widget.answerSelected == 4,
            wrong: widget.answerWrong && widget.answerSelected == 1 || widget.answerWrong && widget.answerSelected == -1,
          )
        ],
      ) :
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