import "package:orios/fetch.dart";

class Quizzes {
  static Future<Map<String, dynamic>> getAll() async => Fetch.get('/quizzes', {});
  static Future<Map<String, dynamic>> getAllInCategory(String category) async => Fetch.get('/quizzes/category/$category', {});
  static Future<Map<String, dynamic>> getRanking() async => Fetch.get('/quizzes/ranking', {});
  static Future<Map<String, dynamic>> getUserRank(String user) async => Fetch.get('/quizzes/ranking/$user', {});
  static Future<Map<String, dynamic>> get(String id) async => Fetch.get('/quizzes/$id', {});
  static Future<Map<String, dynamic>> put(String id, Map<String, dynamic> data) async => Fetch.put('/quizzes/ranking/$id', data, {});
  static Future<Map<String, dynamic>> delete(String id) async => Fetch.delete('/quizzes/$id', {});
}