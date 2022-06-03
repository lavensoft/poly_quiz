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

import 'package:http/http.dart';
import "../../global/global.dart";
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import 'dart:math';

const avatarsImage = [
  "a1.png",
  "a2.png",
  "a3.png",
  "a4.png",
  "a5.png",
  "a6.png",
  "a7.png",
  "a8.png",
  "a9.png",
  "a10.png",
  "a11.png",
  "a12.png",
  "a13.png",
  "a14.png",
  "a15.png",
  "a16.png",
  "a17.png",
  "a18.png",
  "a19.png",
  "a20.png",
  "a21.png",
  "a22.png",
  "a23.png",
  "a24.png",
  "a25.png",
  "a26.png",
  "a27.png",
  "a28.png",
  "a29.png",
  "a30.png",
  "a31.png",
  "a32.png",
  "a33.png",
  "a34.png",
  "a35.png",
  "a36.png",
  "a37.png",
  "a38.png",
];

class API {
  static final Map<String, String> _headers = {
    "Content-Type": "application/json",
    //"w_api_key" : "wNp9EytjOb2WG7YqzqXQJxMqSQBWD8Zh8eRJf7Zo",
    "api_key" : "wNp9EytjOb2WG7YqzqXQJxMqSQBWD8Zh8eRJf7Zo",
    "app_id" : "625453bc7b3cbb43d51602a3",
  };

  static String apiUrl = Global.DEBUG ? "http://localhost:8080" : "https://server.lavenes.com";

  //*USER API
  static Future addUser(String email, String name, String password) async {
    Random random = new Random();

    Response response = await post(Uri.parse("$apiUrl/client_user"), body: utf8.encode(jsonEncode({
      "email": email,
      "name" : name,
      "password" : password,
      "avatar" : avatarsImage[random.nextInt(avatarsImage.length - 1)].toString(),
      "usrData" : {
        "gems" : 500
      }
    })), headers: _headers);

    return json.decode(response.body);
  }

  static Future authUser(String email, String password) async {

    Response response = await post(Uri.parse("$apiUrl/client_user/auth"), body: utf8.encode(jsonEncode({
      "email": email,
      "password" : password,
    })), headers: _headers);

    return json.decode(response.body);
  }

  static Future getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await get(Uri.parse("$apiUrl/client_user/${prefs.getString("userId")}"), headers: _headers);
    return json.decode(response.body)["data"];
  }

  static Future updateUserGems(int gems) async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await patch(Uri.parse("$apiUrl/client_user/${prefs.getString("userId")}"), body: utf8.encode(jsonEncode({
      "usrData" : {
        "gems" : gems
      }
    })), headers: _headers);

    prefs.setInt("gems", gems);

    return json.decode(response.body);
  }

  //*QUIZ API
  static Future getAllQuiz() async{
    Response response = await get(Uri.parse("$apiUrl/quiz"), headers: _headers);
    return json.decode(response.body);
  }

  static Future getSingleQuiz(String quizId) async {
    Response response = await get(Uri.parse("$apiUrl/quiz/$quizId"), headers: _headers);
    return json.decode(response.body);
  }

  static Future getUserQuizRank() async{
    final prefs = await SharedPreferences.getInstance();

    Response response = await get(Uri.parse("$apiUrl/quiz/ranking/${prefs.getString("userId")}"), headers: _headers);
    return json.decode(response.body);
  }

  //*QUIZ ANSWERS API
  static Future addQuizAnswers(String quizId, String questionId, int answer) async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await post(Uri.parse("$apiUrl/quiz_answers"), body: utf8.encode(jsonEncode({
      "questionId" : questionId,
      "answer" : answer,
      "userId" : prefs.getString("userId"),
      "quizId" : quizId,
    })), headers: _headers);

    return json.decode(response.body);
  }
}