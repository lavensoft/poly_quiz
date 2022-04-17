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

//Screens
import 'screens/home/main.dart';
import "screens/quiz/main.dart";
import "screens/auth/login/main.dart";
import "screens/auth/signup/main.dart";
import "screens/gemsExchange/main.dart";

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "GoogleSansPlus"
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/quiz/6259409d99f91815522a374c': (context) => QuizScreen(
          quizId: "6259409d99f91815522a374c",
        ),
        '/quiz/62594fcb99f91815522a374d': (context) => QuizScreen(
          quizId: "62594fcb99f91815522a374d",
        ),
        '/quiz/625950bd99f91815522a374e': (context) => QuizScreen(
          quizId: "625950bd99f91815522a374e",
        ),
        '/quiz/6259518e99f91815522a374f': (context) => QuizScreen(
          quizId: "6259518e99f91815522a374f",
        ),
        '/quiz/625babc5e59853e00c93cf00': (context) => QuizScreen(
          quizId: "625babc5e59853e00c93cf00",
        ),
        '/quiz': (context) => QuizScreen(
          quizId: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/gems_exchange': (context) => GemsExchangeScreen(
          data: ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>,
        ),
        '/': (context) => HomeScreen(),
      },
    );
  }
}
