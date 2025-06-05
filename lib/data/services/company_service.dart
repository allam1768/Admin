import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/company_model.dart';

class CompanyService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api';
  static const String imageBaseUrl = 'https://hamatech.rplrus.com/storage/';

  String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'assets/images/example.png';
    }
    return '$imageBaseUrl$imagePath';
  }

  Future<List<CompanyModel>> getCompanies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/companies'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '1',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> companiesData = responseData['data'];

        return companiesData
            .map((json) => CompanyModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load companies: $e');
    }
  }

  // Fungsi baru untuk membuat company dengan gambar
  Future<CompanyModel> createCompanyWithImage({
    required String name,
    required String address,
    required String phoneNumber,
    required String email,
    File? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/companies'),
      );

      // Tambahkan headers
      request.headers.addAll({
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': '1',
      });

      // Tambahkan field data
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['phone_number'] = phoneNumber;
      request.fields['email'] = email;

      // Tambahkan gambar jika ada
      if (imageFile != null && imageFile.existsSync()) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image', // sesuaikan dengan nama field di backend
          imageFile.path,
        );
        request.files.add(multipartFile);
        print('Image added to request: ${imageFile.path}');
      }

      print('Sending multipart request with data:');
      print('Name: $name');
      print('Address: $address');
      print('Phone: $phoneNumber');
      print('Email: $email');
      print('Image: ${imageFile?.path ?? 'No image'}');

      // Kirim request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if response has the expected structure
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          return CompanyModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response structure');
        }
      } else if (response.statusCode == 422) {
        // Handle validation errors
        final Map<String, dynamic> errorData = json.decode(response.body);
        if (errorData['errors'] != null) {
          String errorMessage = '';
          Map<String, dynamic> errors = errorData['errors'];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessage += '${field}: ${messages.join(', ')}\n';
            }
          });
          throw Exception('Validation error: $errorMessage');
        } else {
          throw Exception('Validation error: ${errorData['message'] ?? 'Unknown validation error'}');
        }
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception('Failed to create company: ${errorData['message'] ?? 'Unknown error'} (${response.statusCode})');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Network error: Periksa koneksi internet Anda');
      }
      throw Exception('Failed to create company: $e');
    }
  }

  // Fungsi lama untuk backward compatibility
  Future<CompanyModel> createCompany(Map<String, dynamic> data) async {
    try {
      print('Sending data to API: ${json.encode(data)}');

      final response = await http.post(
        Uri.parse('$baseUrl/companies'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '1',
        },
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if response has the expected structure
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          return CompanyModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response structure');
        }
      } else if (response.statusCode == 422) {
        // Handle validation errors
        final Map<String, dynamic> errorData = json.decode(response.body);
        if (errorData['errors'] != null) {
          String errorMessage = '';
          Map<String, dynamic> errors = errorData['errors'];
          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessage += '${field}: ${messages.join(', ')}\n';
            }
          });
          throw Exception('Validation error: $errorMessage');
        } else {
          throw Exception('Validation error: ${errorData['message'] ?? 'Unknown validation error'}');
        }
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception('Failed to create company: ${errorData['message'] ?? 'Unknown error'} (${response.statusCode})');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Network error: Periksa koneksi internet Anda');
      }
      throw Exception('Failed to create company: $e');
    }
  }

  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/companies/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '1',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return CompanyModel.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to update company: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update company: $e');
    }
  }

  Future<void> deleteCompany(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/companies/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '1',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete company: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete company: $e');
    }
  }
}