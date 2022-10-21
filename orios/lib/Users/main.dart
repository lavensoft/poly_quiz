import "package:orios/fetch.dart";

class Users {
  static Future<Map<String, dynamic>> authGoogle({ String? idToken, String? accessToken }) async {
    Map<String, dynamic> data = {};

    if(idToken != null) data["idToken"] = idToken;
    if(accessToken != null) data["accessToken"] = accessToken;

    return await Fetch.post('/client_users/auth/google', data, {});
  }
}