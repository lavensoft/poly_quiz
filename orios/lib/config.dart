class OriosConfig {
  static bool debug = false;
  static String url = debug ? 'http://localhost:9000/api/v1' : 'https://orios-server.lavenes.com/api/v1';
  static String cdn = debug ? 'http://localhost:9000' : 'https://orios-server.lavenes.com';
}