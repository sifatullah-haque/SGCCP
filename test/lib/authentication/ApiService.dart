import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final url = Uri.parse('https://app.sgccp-bd.com/api/login');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'email': email, 'password': password});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {'success': false, 'message': 'Error: ${response.reasonPhrase}'};
      }
    } catch (error) {
      return {'success': false, 'message': 'An error occurred: $error'};
    }
  }
}
