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

      print('=== DEBUG WORKER SERVICE ===');
      print('Request URL: $baseUrl/workers');
      print('Response Status: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // PERBAIKAN: Validasi struktur response
        if (!responseData.containsKey('data')) {
          throw Exception('Response does not contain data field');
        }

        final dynamic workersDataRaw = responseData['data'];

        // PERBAIKAN: Pastikan workersData adalah List
        if (workersDataRaw is! List) {
          throw Exception('Data field is not a list: ${workersDataRaw.runtimeType}');
        }

        final List<dynamic> workersData = workersDataRaw;

        print('Total workers found: ${workersData.length}');

        // Debug setiap worker dengan lebih detail
        List<WorkerModel> workers = [];
        for (int i = 0; i < workersData.length; i++) {
          final workerJson = workersData[i];
          print('=== WORKER $i DEBUG ===');
          print('Worker JSON: $workerJson');
          print('Email field exists: ${workerJson.containsKey('email')}');
          print('Email field value: ${workerJson['email']}');
          print('Email is null: ${workerJson['email'] == null}');
          print('Email type: ${workerJson['email']?.runtimeType}');

          try {
            final worker = WorkerModel.fromJson(workerJson);
            workers.add(worker);
            print('Successfully parsed worker: ${worker.name}');
            print('Final email value: "${worker.email}"');
          } catch (e) {
            print('Error parsing worker $i: $e');
            // Lanjutkan dengan worker berikutnya
            continue;
          }
          print('=======================');
        }

        print('Successfully parsed ${workers.length} out of ${workersData.length} workers');
        return workers;

      } else {
        print('HTTP Error: ${response.statusCode}');
        print('Error Body: ${response.body}');
        throw Exception('Failed to load workers: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('=== ERROR IN getWorkers ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: ${StackTrace.current}');
      print('=============================');
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

      print('=== CREATE WORKER DEBUG ===');
      print('URL: $url');
      print('Name: $name');
      print('Email: $email');
      print('Phone: $phoneNumber');
      print('Has profile image: ${profileImage != null}');

      // Membuat request multipart jika ada gambar
      var request = http.MultipartRequest('POST', url);

      // PERBAIKAN: Validasi input sebelum mengirim
      if (name.trim().isEmpty) {
        return LoginResponseModel(
          success: false,
          message: 'Nama tidak boleh kosong',
          user: null,
        );
      }

      if (email.trim().isEmpty || !email.contains('@')) {
        return LoginResponseModel(
          success: false,
          message: 'Email tidak valid',
          user: null,
        );
      }

      if (phoneNumber.trim().isEmpty) {
        return LoginResponseModel(
          success: false,
          message: 'Nomor telepon tidak boleh kosong',
          user: null,
        );
      }

      if (password.trim().isEmpty) {
        return LoginResponseModel(
          success: false,
          message: 'Password tidak boleh kosong',
          user: null,
        );
      }

      // Menambahkan data teks
      request.fields['name'] = name.trim();
      request.fields['email'] = email.trim(); // Pastikan email dikirim dan di-trim
      request.fields['phone_number'] = phoneNumber.trim();
      request.fields['password'] = password;
      request.fields['role'] = 'worker'; // Set role sebagai worker

      print('Request fields: ${request.fields}');

      // Menambahkan file gambar jika ada
      if (profileImage != null) {
        // PERBAIKAN: Validasi file gambar
        if (!await profileImage.exists()) {
          return LoginResponseModel(
            success: false,
            message: 'File gambar tidak ditemukan',
            user: null,
          );
        }

        final fileSize = await profileImage.length();
        print('Image file size: $fileSize bytes');

        if (fileSize > 5 * 1024 * 1024) { // 5MB limit
          return LoginResponseModel(
            success: false,
            message: 'Ukuran file gambar terlalu besar (max 5MB)',
            user: null,
          );
        }

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          profileImage.path,
        ));
      }

      // Mengirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      // PERBAIKAN: Parsing response yang lebih robust
      Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        print('JSON decode error: $e');
        return LoginResponseModel(
          success: false,
          message: 'Invalid response format from server',
          user: null,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // PERBAIKAN: Validasi struktur response sukses
        return LoginResponseModel.fromJson({
          'success': true,
          'message': data['message'] ?? 'Worker berhasil dibuat',
          'user': data['data'] ?? data['user'],
          'token': data['token'],
        });
      } else {
        // PERBAIKAN: Handle berbagai jenis error response
        String errorMessage = 'Gagal membuat akun worker';

        if (data.containsKey('message')) {
          errorMessage = data['message'];
        } else if (data.containsKey('error')) {
          errorMessage = data['error'];
        } else if (data.containsKey('errors')) {
          // Handle validation errors
          final errors = data['errors'];
          if (errors is Map) {
            List<String> errorMessages = [];
            errors.forEach((key, value) {
              if (value is List) {
                errorMessages.addAll(value.cast<String>());
              } else {
                errorMessages.add(value.toString());
              }
            });
            errorMessage = errorMessages.join(', ');
          }
        }

        return LoginResponseModel.fromJson({
          'success': false,
          'message': errorMessage,
        });
      }
    } catch (e) {
      print('=== ERROR IN createWorker ===');
      print('Error type: ${e.runtimeType}');
      print('Error message: $e');
      print('Stack trace: ${StackTrace.current}');
      print('===============================');

      return LoginResponseModel(
        success: false,
        message: 'Terjadi kesalahan saat menghubungi server: $e',
        user: null,
      );
    }
  }

  // TAMBAHAN: Method untuk update worker
  Future<LoginResponseModel> updateWorker({
    required int workerId,
    String? name,
    String? email,
    String? phoneNumber,
    File? profileImage,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/users/$workerId');
      var request = http.MultipartRequest('PUT', url);

      if (name != null && name.trim().isNotEmpty) {
        request.fields['name'] = name.trim();
      }

      if (email != null && email.trim().isNotEmpty) {
        request.fields['email'] = email.trim();
      }

      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        request.fields['phone_number'] = phoneNumber.trim();
      }

      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          profileImage.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson({
          'success': true,
          'message': data['message'] ?? 'Worker berhasil diupdate',
          'user': data['data'],
        });
      } else {
        return LoginResponseModel.fromJson({
          'success': false,
          'message': data['message'] ?? 'Gagal mengupdate worker',
        });
      }
    } catch (e) {
      print('Error updating worker: $e');
      return LoginResponseModel(
        success: false,
        message: 'Terjadi kesalahan saat mengupdate worker.',
        user: null,
      );
    }
  }

  // TAMBAHAN: Method untuk delete worker
  Future<bool> deleteWorker(int workerId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$workerId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting worker: $e');
      return false;
    }
  }
}