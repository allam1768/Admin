import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../app/pages/Login screen/login_controller.dart';
import '../../values/config.dart';
import '../models/LoginResponse_model.dart';
import '../models/client_model.dart';
import 'image_service.dart'; // Import ImageService

class ClientService {
  // Helper method to get the authorization headers
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await LoginController.getToken();
    final headers = Map<String, String>.from(Config.commonHeaders);

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Helper method to get the authorization headers for multipart requests
  static Future<Map<String, String>> _getMultipartAuthHeaders() async {
    final token = await LoginController.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<ClientModel>> fetchClients() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse(Config.getApiUrl('/clients')),
      headers: headers,
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
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse(Config.getApiUrl('/users/$clientId')),
      headers: headers,
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
    final headers = await _getAuthHeaders();
    final response = await http.delete(
      Uri.parse(Config.getApiUrl('/users/$clientId')),
      headers: headers,
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
      final url = Uri.parse(Config.getApiUrl('/clients/register'));
      var request = http.MultipartRequest('POST', url);

      // Get multipart headers including authorization token
      request.headers.addAll(await _getMultipartAuthHeaders());

      request.fields['name'] = username;
      request.fields['email'] = email;
      request.fields['phone_number'] = phoneNumber;
      request.fields['password'] = password;

      // Compress and add profile image if exists
      if (profileImage != null) {
        print('Original client profile image size: ${await profileImage.length()} bytes');

        // Compress image using ImageService
        final compressResult = await ImageService.compressToMax2MB(profileImage);

        File? finalImageFile;
        if (compressResult is File) {
          finalImageFile = compressResult;
          print('Client profile image compressed successfully. New size: ${await finalImageFile.length()} bytes');
        } else {
          print('Client profile image compression failed, using original image');
          finalImageFile = profileImage;
        }

        // Check if image is under limit
        if (await ImageService.isUnderLimit(finalImageFile)) {
          request.files.add(await http.MultipartFile.fromPath(
            'image',
            finalImageFile.path,
          ));
        } else {
          throw Exception('Profile image is too large even after compression. Please use a smaller image.');
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return LoginResponseModel.fromJson({
          'success': true,
          'message': data['message'] ?? 'User berhasil didaftarkan',
          'user': data['data'],
          'token': data['token'],
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
        final url = Uri.parse(Config.getApiUrl('/users/$clientId'));
        print('Request URL: $url');

        var request = http.MultipartRequest('POST', url);
        request.fields['_method'] = 'PUT';

        // Get multipart headers including authorization token
        request.headers.addAll(await _getMultipartAuthHeaders());

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

        request.fields['role'] = 'client';

        // Compress and add profile image if exists
        if (profileImage != null) {
          print('Original client profile image size: ${await profileImage.length()} bytes');

          // Compress image using ImageService
          final compressResult = await ImageService.compressToMax2MB(profileImage);

          File? finalImageFile;
          if (compressResult is File) {
            finalImageFile = compressResult;
            print('Client profile image compressed successfully. New size: ${await finalImageFile.length()} bytes');
          } else {
            print('Client profile image compression failed, using original image');
            finalImageFile = profileImage;
          }

          // Check if image is under limit
          if (await ImageService.isUnderLimit(finalImageFile)) {
            request.files.add(await http.MultipartFile.fromPath(
              'image',
              finalImageFile.path,
            ));
            print('Adding compressed client profile image to request...');
          } else {
            throw Exception('Profile image is too large even after compression. Please use a smaller image.');
          }
        }

        final streamedResponse = await request.send().timeout(
          Config.requestTimeout,
          onTimeout: () {
            throw TimeoutException('Koneksi timeout. Silakan coba lagi.');
          },
        );

        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 302) {
          print('Received 302 redirect. Location: ${response.headers['location']}');
          final redirectLocation = response.headers['location'];
          if (redirectLocation != null) {
            print('Following redirect to: $redirectLocation');
            return LoginResponseModel.fromJson({
              'success': false,
              'message': 'Server mengembalikan redirect (302). Periksa endpoint URL.',
            });
          }
        }

        Map<String, dynamic> data;
        try {
          data = jsonDecode(response.body);
        } catch (e) {
          print('Error parsing JSON response: $e');
          print('Raw response body: ${response.body}');
          if (response.statusCode == 200 || response.statusCode == 201) {
            return LoginResponseModel.fromJson({
              'success': true,
              'message': 'Client berhasil diperbarui',
              'user': null,
            });
          }
          throw Exception('Server response tidak valid: ${response.body}');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          return LoginResponseModel.fromJson({
            'success': true,
            'message': data['message'] ?? 'Client berhasil diperbarui',
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
            'message': data['message'] ??
                'Gagal memperbarui client (${response.statusCode})',
          });
        }
      } catch (e) {
        print('Error updating client (attempt ${retryCount + 1}): $e');
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(
              Duration(seconds: 2 * retryCount));
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
}