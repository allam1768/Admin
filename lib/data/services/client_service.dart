import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/LoginResponse_model.dart';
import '../models/client_model.dart';

class ClientService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api/clients';
  static const String createUserUrl = 'https://hamatech.rplrus.com/api/users';

  static Future<List<ClientModel>> fetchClients() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final data = jsonDecode(response.body);
        final List rawList = data['data'];
        return rawList.map((e) => ClientModel.fromJson(e)).toList();
      } else {
        print('Error response: ${response.body}');
        throw Exception(
            'Failed to fetch clients (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error parsing response: $e');
      throw Exception('Failed to parse response: $e');
    }
  }

  static Future<bool> deleteClient(int clientId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$clientId'),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Client deleted successfully');
        return true;
      } else {
        print('Error deleting client: ${response.body}');
        throw Exception(
            'Failed to delete client (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Error deleting client: $e');
      throw Exception('Failed to delete client: $e');
    }
  }

  static Future<LoginResponseModel> createClient({
    required String username,
    required String phoneNumber,
    required String password,
    File? profileImage,
  }) async {
    try {
      final url = Uri.parse(createUserUrl); // Menggunakan URL /api/users

      // Membuat request multipart untuk mengirim data dengan gambar
      var request = http.MultipartRequest('POST', url);

      // Menambahkan data teks
      request.fields['name'] = username;
      request.fields['phone_number'] = phoneNumber;
      request.fields['password'] = password;
      request.fields['role'] = 'client'; // Set role sebagai client

      // Menambahkan file gambar jika ada
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          profileImage.path,
        ));
      }

      // Mengirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Sesuaikan dengan struktur response API yang baru
        return LoginResponseModel.fromJson({
          'success': true,
          'message': data['message'] ?? 'User berhasil didaftarkan',
          'user': data['data'], // Data user dari response API
          'token': data['token'], // Token dari response API
        });
      } else {
        final data = jsonDecode(response.body);
        return LoginResponseModel.fromJson({
          'success': false,
          'message': data['message'] ?? 'Gagal membuat akun client',
          'user': null,
          'token': null,
        });
      }
    } catch (e) {
      print('Error creating client: $e');
      return LoginResponseModel(
        success: false,
        message: 'Terjadi kesalahan saat menghubungi server: ${e.toString()}',
        user: null,
        token: null,
      );
    }
  }
}