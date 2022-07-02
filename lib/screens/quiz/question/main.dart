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
    required this.quizData,
    required this.questionProgress,
    required this.gems,
    required this.countTime,
    required this.scaleAnimation,
    required this.rotateAnimation,
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
  final dynamic quizData;
  final Animation<double> scaleAnimation;
  final Animation<double> rotateAnimation;

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
    return Stack(
      children: [
        if(widget.quizData["moreData"]["logo"] != null) Positioned(
          top: 24,
          left: 0,
          child: Container(
            width: 150,
            height: 96,
            color: Colors.transparent,
            child: Image.network(widget.quizData["moreData"]["logo"], fit: BoxFit.contain),
          )
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QuestionGroup(),
            !isMobile(context) ? const SizedBox(height: 24) : SizedBox(height: (widget.questionData["isEmoji"] ?? false) ? 12 : 0),
            AnswerGroup()
          ],
        )
      ]
    );
  }

  //*QUESTION GROUP
  Widget QuestionGroup() {
    return Container(
      width: 640,
      //height: (widget.questionData["isEmoji"] ?? false) && (widget.questionData["image"] != null) ? 250 : null,
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
              (widget.showGems) ? Expanded(
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
          if(widget.questionData["image"] != null) ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 128
            ),
            child: (widget.answerSelected < 0 && (widget.questionData["isEmoji"] ?? false)) ? 
              Image.network(
                widget.questionData["image"],
              ) : RotationTransition(
                turns: widget.scaleAnimation,
                child: ScaleTransition(
                  scale: widget.scaleAnimation,
                  child: Text(widget.questionData["answers"][widget.answerSelected], style: const TextStyle(fontSize: 86))
                )
              ),
          ),
          SizedBox(
            height: (widget.answerSelected < 0 && widget.questionData["image"] != null && (widget.questionData["isEmoji"] ?? false)) ? 32 : 60
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (widget.answerSelected < 0 && (widget.questionData["isEmoji"] ?? false)) ? 
                widget.questionData["question"] : "Cảm ơn bạn đã đóng góp ý kiến!",
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
        runSpacing: 5,
        children: [
          TextSelectBox(
            label: "😟", 
            isEmoji: isEmoji,
            onPressed: () {
              handleAnswer(0);
              // if (_rotateController.isAnimating) {
              //   _rotateController.stop(canceled: false);
              // } else {
              //   _rotateController.forward();
              // }
              // if (_scaleController.isAnimating) {
              //   _scaleController.stop(canceled: false);
              // } else {
              //   _scaleController.forward();
              // }
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