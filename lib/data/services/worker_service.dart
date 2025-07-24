import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../app/pages/Login screen/login_controller.dart';
import '../models/worker_model.dart';
import '../models/LoginResponse_model.dart';

class WorkerService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api';

  // Helper method to get the authorization headers for JSON requests
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await LoginController.getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper method to get the authorization headers for multipart requests
  static Future<Map<String, String>> _getMultipartAuthHeaders() async {
    final token = await LoginController.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<WorkerModel>> getWorkers() async {
    try {
      final headers = await _getAuthHeaders(); // Use auth headers
      final response = await http.get(
        Uri.parse('$baseUrl/workers'),
        headers: headers,
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

      // Membuat request multipart
      var request = http.MultipartRequest('POST', url);

      // Add auth headers for multipart request
      request.headers.addAll(await _getMultipartAuthHeaders());

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

  Future<LoginResponseModel> updateWorker({
    required String workerId,
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    File? profileImage,
  }) async {
    int maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final url = Uri.parse('$baseUrl/users/$workerId');
        print('Request URL: $url');

        var request = http.MultipartRequest('POST', url);

        // Add auth headers for multipart request
        request.headers.addAll(await _getMultipartAuthHeaders());

        request.fields['_method'] = 'PUT';

        if (name != null && name.trim().isNotEmpty) {
          request.fields['name'] = name.trim();
        }
        if (email != null && email.trim().isNotEmpty) {
          request.fields['email'] = email.trim();
        }
        if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
          request.fields['phone_number'] = phoneNumber.trim();
        }
        if (password != null && password.trim().isNotEmpty) {
          request.fields['password'] = password.trim();
        }

        request.fields['role'] = 'worker';

        if (profileImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            profileImage.path,
          ));
          print('Adding profile image to request...');
        }

        print('Sending POST request with _method: PUT...');
        print('Request fields: ${request.fields}');
        print('Request files: ${request.files.length} file(s)');

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Koneksi timeout. Silakan coba lagi.');
          },
        );

        final response = await http.Response.fromStream(streamedResponse);

        print('Response status for update: ${response.statusCode}');
        print('Response body for update: ${response.body}');

        Map<String, dynamic> data;
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          print('Error parsing JSON response: $e');
          throw Exception('Server response tidak valid');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          return LoginResponseModel.fromJson({
            'success': true,
            'message': data['message'] ?? 'Worker berhasil diperbarui',
            'user': data['data'] ?? data['user'],
            'token': data['token'],
          });
        } else if (response.statusCode == 422) {
          String errorMessage = 'Validation error';
          if (data['message'] != null) {
            errorMessage = data['message'];
          } else if (data['errors'] != null) {
            List<String> errors = [];
            Map<String, dynamic> validationErrors = data['errors'];
            validationErrors.forEach((key, value) {
              if (key == 'email' && value is List) {
                List<String> emailErrors = value.cast<String>();
                if (email == null) {
                  print('Email field not being updated, skipping email validation errors');
                  return;
                }
                errors.addAll(emailErrors);
              } else if (value is List) {
                errors.addAll(value.cast<String>());
              }
            });

            if (errors.isNotEmpty) {
              errorMessage = errors.join(', ');
            } else {
              errorMessage = 'Data berhasil diperbarui';
              return LoginResponseModel.fromJson({
                'success': true,
                'message': errorMessage,
                'user': data['data'] ?? data['user'],
              });
            }
          }

          return LoginResponseModel.fromJson({
            'success': false,
            'message': errorMessage,
          });
        } else {
          return LoginResponseModel.fromJson({
            'success': false,
            'message': data['message'] ?? 'Gagal memperbarui worker (${response.statusCode})',
          });
        }
      } catch (e) {
        print('Error updating worker (attempt ${retryCount + 1}): $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 2 * retryCount));
          continue;
        }
        String errorMessage = 'Terjadi kesalahan saat menghubungi server.';
        if (e.toString().contains('timeout') || e is TimeoutException) {
          errorMessage = 'Koneksi timeout. Silakan coba lagi.';
        } else if (e.toString().contains('Failed host lookup') || e.toString().contains('SocketException')) {
          errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        }
        return LoginResponseModel(
          success: false,
          message: errorMessage,
          user: null,
        );
      }
    }
    return LoginResponseModel(
      success: false,
      message: 'Gagal terhubung ke server setelah beberapa percobaan.',
      user: null,
    );
  }

  static Future<bool> deleteWorker(String workerId) async {
    try {
      final headers = await _getAuthHeaders(); // Use auth headers
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$workerId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] ?? true;
      } else if (response.statusCode == 204) {
        return true;
      } else {
        print('Failed to delete worker: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting worker: $e');
      throw Exception('Failed to delete worker: $e');
    }
  }
}