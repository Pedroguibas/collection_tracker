import "package:http/http.dart" as http;

class Validator {
  static Future<bool> validateImgUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));

      final contentType = response.headers['content-type'];

      return contentType != null && contentType.startsWith("image/");
    } catch (e) {
      return false;
    }
  }
}
