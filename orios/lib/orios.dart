library orios;
import 'dart:convert';

import "package:shared_preferences/shared_preferences.dart";

class AppConfig {
  String apiKey = "";
  String app = "";

  AppConfig(Map<String, dynamic> json) {
    apiKey = json["apiKey"];
    app = json["app"];
  }

  Map<String, dynamic> toJson() {
    return {
      "apiKey": apiKey,
      "app" : app
    };
  }
}

class Orios {
  //Init app
  static Future initializeApp (AppConfig config) async {
    var prefs = await SharedPreferences.getInstance();

    //*SAVE INIT
    prefs.setString("@ors", jsonEncode(config.toJson()));
  }

  //Get header
  static Future getHeaders() async {
    var prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> configJson = jsonDecode(prefs.getString("@ors") ?? "{}");

    return configJson;
  }
}