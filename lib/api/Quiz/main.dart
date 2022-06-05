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
import "dart:convert";
import "package:shared_preferences/shared_preferences.dart";
import 'dart:math';
import "../config.dart";

class QuizAPI {
  static Future getAll() async{
    Response response = await get(Uri.parse("${APIConfig.API}/quizzes"), headers: APIConfig.HEADERS);
    return json.decode(response.body);
  }

  static Future getQuizData(String quizId) async {
    Response response = await get(Uri.parse("${APIConfig.API}/quizzes/$quizId"), headers: APIConfig.HEADERS);
    return json.decode(response.body);
  }

  static Future getUserQuizRank() async{
    final prefs = await SharedPreferences.getInstance();

    Response response = await get(Uri.parse("${APIConfig.API}/quizzes/ranking/${prefs.getString("userId")}"), headers: APIConfig.HEADERS);
    return json.decode(response.body);
  }

  static Future addQuizAnswer(String quizId, String questionId, int answer) async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await post(Uri.parse("${APIConfig.API}/quiz_answers"), body: utf8.encode(jsonEncode({
      "questionId" : questionId,
      "answer" : answer,
      "userId" : prefs.getString("userId"),
      "quizId" : quizId,
    })), headers: {
      ...APIConfig.HEADERS,
      "authorization" : prefs.getString("token") ?? ""
    });

    return json.decode(response.body);
  }
}