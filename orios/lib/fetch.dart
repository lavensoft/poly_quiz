import 'package:http/http.dart' as http;
import "dart:convert";
import "package:orios/config.dart";
import "package:orios/orios.dart";

class Fetch {
  static Future<Map<String, dynamic>> get(String url, Map<String, dynamic> headers) async {
    http.Response response = await http.get(Uri.parse("${OriosConfig.url}$url"), headers: {
      ...await Orios.getHeaders(),
      ...headers
    });

    Map<String, dynamic> result = jsonDecode(response.body);

    return result["data"];
  }

  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data, Map<String, dynamic> headers) async {
    http.Response response = await http.post(Uri.parse("${OriosConfig.url}$url"), body: utf8.encode(jsonEncode(data)), headers: {
      ...await Orios.getHeaders(),
      ...headers
    });

    Map<String, dynamic> result = jsonDecode(response.body);

    return result["data"];
  }

  static Future<Map<String, dynamic>> put(String url, Map<String, dynamic> data, Map<String, dynamic> headers) async {
    http.Response response = await http.post(Uri.parse("${OriosConfig.url}$url"), body: utf8.encode(jsonEncode(data)), headers: {
      ...await Orios.getHeaders(),
      ...headers
    });

    Map<String, dynamic> result = jsonDecode(response.body);

    return result["data"];
  }

  static Future<Map<String, dynamic>> delete(String url, Map<String, dynamic> headers) async {
    http.Response response = await http.post(Uri.parse("${OriosConfig.url}$url"), headers: {
      ...await Orios.getHeaders(),
      ...headers
    });

    Map<String, dynamic> result = jsonDecode(response.body);

    return result["data"];
  }
}