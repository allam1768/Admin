import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/LoginResponse_model.dart';

class LoginService {
  static const String baseUrl = 'https://643f-36-81-9-171.ngrok-free.app/api';

  static Future<LoginResponseModel> login({
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson({
          'success': true,
          'message': data['message'],
          'user': data['user'],
        });
      } else {
        return LoginResponseModel.fromJson({
          'success': false,
          'message': data['message'] ?? 'Login gagal',
        });
      }
    } catch (e) {
      print('Catch error: $e');
      return LoginResponseModel(
        success: false,
        message: 'Terjadi kesalahan saat menghubungi server.',
        user: null,
      );
    }
  }
}
