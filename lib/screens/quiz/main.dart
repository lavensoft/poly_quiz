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
import "package:flutter/cupertino.dart";
import "package:quizz/lavenes.dart";
import "package:shared_preferences/shared_preferences.dart";
import "./play/main.dart";
import "./question/main.dart";
import "./congras/main.dart";
import "../../global/global.dart";
import "dart:async";

class QuizScreen extends StatefulWidget {
  QuizScreen({Key? key, required this.quizId}) : super(key : key);

  final String quizId;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var quizData;
  var questionData;
  List<int> userAnswers = [];

  //*SCREEN VISIBLE
  bool playScreenVisible = true;
  bool questionScreenVisible = false;
  bool congrasScreenVisible = false;
  bool betScreenVisible = false;
  bool endScreenVisible = false;
  bool loadingScreenVisible = false;
  bool isLoading = true;

  //*QUESTION SCREEN
  int questionCountdown = 11;
  int answerSelected = -1;
  int questionIndex = 0;
  bool answerWrong = false;
  bool answerCorrect = false;
  bool isWaitingQuestion = false;
  Timer? countDownTimer;

  //*BET GEMS SCREEN
  List<int> betValues = [25, 50, 75, 100];
  int betSelected = -1;
  int gemsBet = 0;
  bool useBetFeature = false;

  //*QUESTION
  int gems = 0;
  int oldGems = 0;
  int gemsAfterAnswer = 0;

  @override
  void initState() {
    super.initState();

    API.getSingleQuiz(widget.quizId).then((result) {
      var argQuizData = result["data"];
      var argQuestionsData = argQuizData["questions"];

      argQuestionsData = shuffle(argQuestionsData); //*SHUFFLE QUESTIONS

      if(argQuizData["moreData"]?["questionsPerRound"] != null) { //*LIMIT QUESTIONS
        argQuestionsData = argQuestionsData.sublist(0, argQuizData["moreData"]["questionsPerRound"]);
      }

      setState(() {
        quizData = argQuizData;
        questionData = argQuestionsData;
        gemsBet = argQuestionsData[0]["score"].toInt(); //*Set score per question
        isLoading = false;
      });
    });

    _loadGems();
  }

  //*LOAD
  void _loadGems() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      gems = prefs.getInt("gems") ?? 0;
    });
  }

  //*WHEN FINISH
  void _handleFinishGame() async{
    //* Update user gems
    await API.updateUserGems(gems);

    //*Update user answers
    int index = 0;

    await Future.forEach(userAnswers, (element) async {
      await API.addQuizAnswers(quizData["_id"], questionData[index]["id"], int.parse(element.toString())).then((value) {
        if(value["code"] == 200) {
          index++;
        }
      });
    });

    setState(() {
      loadingScreenVisible = false;
    });

    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    void calculateGemsAfterAnswer(int value) {
      setState(() {
        oldGems = gems;
        gemsAfterAnswer = value;
      });

      setState(() {
        gemsBet = 0;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          gems = gems + value;
          if((gems + value) > 0) congrasScreenVisible = true;
          if((gems + value) <= 0 || questionIndex >= questionData.length - 1) {
            congrasScreenVisible = true;
            endScreenVisible = true;
          }
          questionScreenVisible = false;
          questionCountdown = 11;
        });
      });
    }

    void handleAnswer(int index) {
      if(answerSelected == -1 && index != -2 && !isWaitingQuestion) {
        List<int> tUserAnswers = userAnswers;
        tUserAnswers.add(index);

        setState(() {
          answerSelected = index;
          isWaitingQuestion = true;
          userAnswers = tUserAnswers;
        });

        countDownTimer!.cancel();

        Future.delayed(const Duration(seconds: 1), () {
          if(questionData[questionIndex]["correct"].indexOf(index) > -1) {
            setState(() {
              answerCorrect = true;
              answerWrong = false;
            });

            calculateGemsAfterAnswer(gemsBet * (useBetFeature ? 2 : 1));
          } else {
            setState(() {
              answerCorrect = false;
              answerWrong = true;
            });

            calculateGemsAfterAnswer(-gemsBet);
          }
        });
      }else if(!isWaitingQuestion){
        setState(() {
          answerSelected = -1;
          isWaitingQuestion = true;
          answerWrong = true;
        });

        countDownTimer!.cancel();

        Future.delayed(const Duration(seconds: 1), () {
          calculateGemsAfterAnswer(-gemsBet);
          setState(() {
            isWaitingQuestion = false;
          });
        });
      }
    }

    void handleShowQuestion() {
      Timer newCountDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          questionCountdown --;
        });

        if(questionCountdown <= 0) {
            timer.cancel();
            handleAnswer(-2);
        }
      });

      setState(() {
        questionCountdown = 11;
        countDownTimer = newCountDownTimer;
        questionScreenVisible = true;
      });
    }

    void handlePlay() {
      handleShowQuestion();
      setState(() {
        playScreenVisible  = false;
      });
    }

    void handleNextQuestion() {
      if(questionIndex < questionData.length - 1 && !endScreenVisible) {
        setState(() {
          answerSelected = -1;
          answerWrong = false;
          answerCorrect = false;
          congrasScreenVisible = false;
          isWaitingQuestion = false;
          questionIndex ++;
          gemsBet = questionData[questionIndex]["score"].toInt(); //*Set score per question
          if(useBetFeature) {
            betScreenVisible = true;
          }
        });

        Future.delayed(const Duration(milliseconds: 650), () {
          handleShowQuestion();
        });
      }else if(!endScreenVisible) {
        setState(() {
          congrasScreenVisible = true;
          endScreenVisible = true;
        });
      }else{
        setState(() {
          loadingScreenVisible = true;
        });

        _handleFinishGame();
      }
    }

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
            child: Stack(
              alignment: Alignment.center,
              children: !isLoading ? [
                //* PLAY SCREEN
                AnimatedSlide(
                  offset: Offset(playScreenVisible ? 0 : -2 , 0), 
                  duration: const Duration(milliseconds: 750),
                  child:  AnimatedOpacity(
                    opacity: playScreenVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 750),
                    child: QuizPlayScreen(
                      title: quizData["title"],
                      subtitle: quizData["category"],
                      description: quizData["description"],
                      image: quizData["banner"],
                      onPlay: () {
                        handlePlay();
                      },
                    ),
                  ),
                ),

                //* QUESTION SCREEN
                AnimatedSlide(
                  offset: Offset(
                    questionScreenVisible ? 0 : congrasScreenVisible ? -2 : 2 ,
                    0), 
                  duration: const Duration(milliseconds: 750),
                  child:  AnimatedOpacity(
                    opacity: questionScreenVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 750),
                    child: QuestionScreen(
                      questionData: questionData[questionIndex],
                      questionCountdown: questionCountdown,
                      answerWrong: answerWrong,
                      answerCorrect: answerCorrect,
                      answerSelected: answerSelected,
                      gems: gems,
                      questionProgress: questionIndex / (questionData.length - 1),
                      onAnswer: (index) {
                        handleAnswer(index);
                      },
                    ),
                  ),
                ),

                //* CONGRATULATION SCREEN
                AnimatedSlide(
                  offset: Offset(congrasScreenVisible ? 0 :  questionScreenVisible ? 2 : -2 , 0), 
                  duration: const Duration(milliseconds: 720),
                  child:  AnimatedOpacity(
                    opacity: congrasScreenVisible ? 1 : 0,
                    duration: const Duration(milliseconds: 720),
                    child: CongrasScreen(
                      loading: loadingScreenVisible,
                      gems: gems,
                      endScreenVisible: endScreenVisible,
                      gemsAfterAnswer: gemsAfterAnswer,
                      onContinue: () {
                        handleNextQuestion();
                      },
                    ),
                  ),
                ),
              ] : [
                  //*LOADING
                  Container(
                    margin: const EdgeInsets.only(bottom: 72),
                    child: const CupertinoActivityIndicator(
                      animating: true,
                      radius: 14,
                    ),
                  ),
                  const Text(
                    "Bạn đợi một chút xíu nhé...",
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
            ),
          )
        )
      )
    );
  }
}