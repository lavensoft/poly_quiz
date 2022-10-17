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

class UserAPI {
  static Future add(String email, String name, String password) async {
    Random random = new Random();

    Response response = await post(Uri.parse("${APIConfig.API}/client_users"), body: utf8.encode(jsonEncode({
      "email": email,
      "name" : name,
      "password" : password,
      "avatar" : avatarsImage[random.nextInt(avatarsImage.length - 1)].toString(),
      "data" : {
        "gems" : 500
      }
    })), headers: APIConfig.HEADERS);

    return json.decode(response.body);
  }

  static Future authGoogle(String? token) async {
    if(token != null) {
      Response response = await post(Uri.parse("${APIConfig.API}/client_users/auth/google"), body: utf8.encode(jsonEncode({
        "token": token
      })), headers: APIConfig.HEADERS);

      return json.decode(response.body);
    }
  }

  static Future auth(String email, String password) async {
    Response response = await post(Uri.parse("${APIConfig.API}/client_users/auth"), body: utf8.encode(jsonEncode({
      "email": email,
      "password" : password
    })), headers: APIConfig.HEADERS);

    return json.decode(response.body);
  }

  static Future getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await get(
      Uri.parse("${APIConfig.API}/client_users/${prefs.getString("userId")}"), 
      headers: APIConfig.HEADERS
    );
    return json.decode(response.body)["data"];
  }

  static Future updateGems(int gems) async {
    final prefs = await SharedPreferences.getInstance();

    Response response = await patch(Uri.parse("${APIConfig.API}/client_users/${prefs.getString("userId")}"), body: utf8.encode(jsonEncode({
      "data" : {
        "gems" : gems
      }
    })), headers: APIConfig.HEADERS);

    prefs.setInt("gems", gems);

    return json.decode(response.body);
  }
}
