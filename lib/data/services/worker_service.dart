import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/worker_model.dart';
import '../models/LoginResponse_model.dart';

class WorkerService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api';

  Future<List<WorkerModel>> getWorkers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/workers'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> workersData = responseData['data'];

        return workersData.map((json) => WorkerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load workers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load workers: $e');
    }
  }

  Future<LoginResponseModel> createWorker({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    File? profileImage,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/users');

      // Membuat request multipart jika ada gambar
      var request = http.MultipartRequest('POST', url);

      // Menambahkan data teks
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['phone_number'] = phoneNumber;
      request.fields['password'] = password;
      request.fields['role'] = 'worker'; // Set role sebagai worker

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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson({
          'success': true,
          'message': data['message'],
          'user': data['data'],
          'token': data['token'],
        });
      } else {
        return LoginResponseModel.fromJson({
          'success': false,
          'message': data['message'] ?? 'Gagal membuat akun worker',
        });
      }
    } catch (e) {
      print('Error creating worker: $e');
      return LoginResponseModel(
        success: false,
        message: 'Terjadi kesalahan saat menghubungi server.',
        user: null,
      );
    }
  }
}