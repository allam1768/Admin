import 'dart:async';
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

  // Metode yang diperbaiki untuk memperbarui pekerja berdasarkan ID
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
        print('=== UPDATE WORKER REQUEST ===');
        print('Worker ID: $workerId');
        print('Name: $name');
        print('Email: $email');
        print('Phone: $phoneNumber');
        print('Has image: ${profileImage != null}');

        final url = Uri.parse('$baseUrl/users/$workerId');
        print('Request URL: $url');

        // Gunakan HTTP PUT dengan JSON untuk data tanpa file
        // atau MultipartRequest jika ada file
        http.Response response;

        if (profileImage != null) {
          // Jika ada gambar, gunakan MultipartRequest
          var request = http.MultipartRequest('POST', url);

          // Tambahkan _method untuk override HTTP method
          request.fields['_method'] = 'PUT';

          // Menambahkan data teks hanya jika disediakan dan tidak kosong
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

          // Pastikan role tetap worker
          request.fields['role'] = 'worker';

          // Menambahkan file gambar
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            profileImage.path,
          ));

          print('Sending multipart request with image...');
          final streamedResponse = await request.send().timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Koneksi timeout. Silakan coba lagi.');
            },
          );
          response = await http.Response.fromStream(streamedResponse);
        } else {
          // Jika tidak ada gambar, gunakan HTTP PUT dengan JSON
          Map<String, dynamic> updateData = {};

          // Hanya tambahkan field yang tidak null dan tidak kosong
          if (name != null && name.trim().isNotEmpty) {
            updateData['name'] = name.trim();
          }
          if (email != null && email.trim().isNotEmpty) {
            updateData['email'] = email.trim();
          }
          if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
            updateData['phone_number'] = phoneNumber.trim();
          }
          if (password != null && password.trim().isNotEmpty) {
            updateData['password'] = password.trim();
          }

          // Pastikan role tetap worker
          updateData['role'] = 'worker';

          print('Sending JSON PUT request...');
          print('Update data: $updateData');

          // Jika tidak ada data yang diupdate, kirim minimal data role
          if (updateData.isEmpty || updateData.length == 1) {
            print('No significant data to update, sending minimal request...');
          }

          response = await http.put(
            url,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(updateData),
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException('Koneksi timeout. Silakan coba lagi.');
            },
          );
        }

        print('Response status for update: ${response.statusCode}');
        print('Response body for update: ${response.body}');

        // Parsing response yang lebih robust
        Map<String, dynamic> data;
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          print('Error parsing JSON response: $e');
          throw Exception('Server response tidak valid');
        }

        // Handle berbagai status code sukses
        if (response.statusCode == 200 || response.statusCode == 201) {
          return LoginResponseModel.fromJson({
            'success': true,
            'message': data['message'] ?? 'Worker berhasil diperbarui',
            'user': data['data'] ?? data['user'], // Coba kedua kemungkinan key
            'token': data['token'], // Token mungkin tidak ada pada update
          });
        } else if (response.statusCode == 422) {
          // Validation error
          String errorMessage = 'Validation error';
          if (data['message'] != null) {
            errorMessage = data['message'];
          } else if (data['errors'] != null) {
            // Format error dari Laravel validation
            List<String> errors = [];
            Map<String, dynamic> validationErrors = data['errors'];
            validationErrors.forEach((key, value) {
              // Skip error jika itu tentang email yang sudah ada tapi tidak diubah
              if (key == 'email' && value is List) {
                List<String> emailErrors = value.cast<String>();
                // Filter out "email already taken" jika email tidak diubah
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
              errorMessage = 'Data berhasil diperbarui'; // Jika tidak ada error yang relevan
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

        // Jika masih ada kesempatan retry, tunggu sebentar lalu coba lagi
        if (retryCount < maxRetries) {
          await Future.delayed(Duration(seconds: 2 * retryCount)); // Backoff strategy
          continue;
        }

        // Jika sudah mencapai batas retry, kembalikan error
        String errorMessage = 'Terjadi kesalahan saat menghubungi server.';

        if (e.toString().contains('timeout') || e is TimeoutException) {
          errorMessage = 'Koneksi timeout. Silakan coba lagi.';
        } else if (e.toString().contains('Failed host lookup')) {
          errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        }

        return LoginResponseModel(
          success: false,
          message: errorMessage,
          user: null,
        );
      }
    }

    // Fallback jika semua retry gagal (seharusnya tidak pernah sampai sini)
    return LoginResponseModel(
      success: false,
      message: 'Gagal terhubung ke server setelah beberapa percobaan.',
      user: null,
    );
  }

  static Future<bool> deleteWorker(String workerId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$workerId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
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