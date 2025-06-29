import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/LoginResponse_model.dart';
import '../models/client_model.dart';

class ClientService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api/clients';
  static const String createUserUrl = 'https://hamatech.rplrus.com/api/clients/register'; // Updated endpoint
  static const String userDetailUrl = 'https://hamatech.rplrus.com/api/users';

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

  static Future<ClientModel?> fetchClientDetail(int clientId) async {
    final response = await http.get(
      Uri.parse('$userDetailUrl/$clientId'),
      headers: {'Content-Type': 'application/json'},
    );

    try {
      if (response.statusCode == 200) {
        print('Client detail response: ${response.body}');
        final data = jsonDecode(response.body);
        return ClientModel.fromJson(data['data']);
      } else {
        print('Error fetching client detail: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error parsing client detail: $e');
      return null;
    }
  }

  static Future<bool> deleteClient(int clientId) async {
    final response = await http.delete(
      Uri.parse('https://hamatech.rplrus.com/api/users/$clientId'), // Keep using users endpoint for delete
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
    required String email,
    required String phoneNumber,
    required String password,
    File? profileImage,
  }) async {
    try {
      final url = Uri.parse(createUserUrl); // Using new endpoint /api/clients/register

      // Membuat request multipart untuk mengirim data dengan gambar
      var request = http.MultipartRequest('POST', url);

      // Menambahkan data teks (removed role field)
      request.fields['name'] = username;
      request.fields['email'] = email;
      request.fields['phone_number'] = phoneNumber;
      request.fields['password'] = password;
      // Role field removed as per requirement

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

  static Future<LoginResponseModel> updateClient({
    required String clientId,
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

        // PERBAIKAN: Gunakan endpoint yang sama dengan worker service
        final url = Uri.parse('https://hamatech.rplrus.com/api/users/$clientId'); // Gunakan /api/users untuk update
        print('Request URL: $url');

        // Selalu gunakan POST dengan _method: PUT untuk konsistensi
        var request = http.MultipartRequest('POST', url);

        // Tambahkan _method untuk override HTTP method ke PUT
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

        // Pastikan role tetap client
        request.fields['role'] = 'client';

        // PERBAIKAN: Tambahkan header yang sama dengan worker service
        request.headers.addAll({
          'Accept': 'application/json',
        });

        // Menambahkan file gambar jika ada
        if (profileImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            profileImage.path,
          ));
          print('Adding profile image to request...');
        }



        // Kirim request
        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Koneksi timeout. Silakan coba lagi.');
          },
        );

        final response = await http.Response.fromStream(streamedResponse);



        // PERBAIKAN: Handle redirect 302 secara eksplisit
        if (response.statusCode == 302) {
          print('Received 302 redirect. Location: ${response.headers['location']}');

          // Coba ikuti redirect secara manual jika diperlukan
          final redirectLocation = response.headers['location'];
          if (redirectLocation != null) {
            print('Following redirect to: $redirectLocation');
            // Untuk sementara, anggap ini sebagai error karena biasanya 302 di API REST menandakan masalah
            return LoginResponseModel.fromJson({
              'success': false,
              'message': 'Server mengembalikan redirect (302). Periksa endpoint URL.',
            });
          }
        }

        // Parsing response yang lebih robust
        Map<String, dynamic> data;
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          print('Error parsing JSON response: $e');
          print('Raw response body: ${response.body}');

          // Jika response body kosong atau bukan JSON, tapi status code sukses
          if (response.statusCode == 200 || response.statusCode == 201) {
            return LoginResponseModel.fromJson({
              'success': true,
              'message': 'Client berhasil diperbarui',
              'user': null,
            });
          }

          throw Exception('Server response tidak valid: ${response.body}');
        }

        // Handle berbagai status code sukses
        if (response.statusCode == 200 || response.statusCode == 201) {
          return LoginResponseModel.fromJson({
            'success': true,
            'message': data['message'] ?? 'Client berhasil diperbarui',
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
                  print(
                      'Email field not being updated, skipping email validation errors');
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
              errorMessage =
              'Data berhasil diperbarui'; // Jika tidak ada error yang relevan
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
            'message': data['message'] ??
                'Gagal memperbarui client (${response.statusCode})',
          });
        }
      } catch (e) {
        print('Error updating client (attempt ${retryCount + 1}): $e');
        retryCount++;

        // Jika masih ada kesempatan retry, tunggu sebentar lalu coba lagi
        if (retryCount < maxRetries) {
          await Future.delayed(
              Duration(seconds: 2 * retryCount)); // Backoff strategy
          continue;
        }

        // Jika sudah mencapai batas retry, kembalikan error
        String errorMessage = 'Terjadi kesalahan saat menghubungi server.';

        if (e.toString().contains('timeout') || e is TimeoutException) {
          errorMessage = 'Koneksi timeout. Silakan coba lagi.';
        } else if (e.toString().contains('Failed host lookup')) {
          errorMessage =
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        } else if (e.toString().contains('SocketException')) {
          errorMessage =
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
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
}