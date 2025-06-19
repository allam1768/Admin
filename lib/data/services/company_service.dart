import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  // Function to get client ID from SharedPreferences
  Future<String?> getClientId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('client_id');
    } catch (e) {
      print('Error getting client ID: $e');
      return null;
    }
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

  // Updated function to create company with client ID and image, including company_qr generation
  Future<CompanyModel> createCompanyWithImage({
    required String name,
    required String address,
    required String phoneNumber,
    required String email,
    File? imageFile,
    String? clientId, // Optional parameter, will use stored ID if not provided
    String? companyQr, // Optional QR code, server will generate if not provided
  }) async {
    try {
      // Get client ID if not provided
      String? finalClientId = clientId ?? await getClientId();

      if (finalClientId == null || finalClientId.isEmpty) {
        throw Exception('Client ID not found. Please login again.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/companies'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': '1',
      });

      // Add form fields including client_id
      request.fields['client_id'] = finalClientId;
      request.fields['name'] = name;
      request.fields['address'] = address;
      request.fields['phone_number'] = phoneNumber;
      request.fields['email'] = email;

      // Add company QR if provided (let server generate if not provided)
      if (companyQr != null && companyQr.isNotEmpty) {
        request.fields['company_qr'] = companyQr;
      }

      // Add image if exists
      if (imageFile != null && imageFile.existsSync()) {
        var multipartFile = await http.MultipartFile.fromPath(
          'image', // adjust according to backend field name
          imageFile.path,
        );
        request.files.add(multipartFile);
        print('Image added to request: ${imageFile.path}');
      }

      print('Sending multipart request with data:');
      print('Client ID: $finalClientId');
      print('Name: $name');
      print('Address: $address');
      print('Phone: $phoneNumber');
      print('Email: $email');
      print('Company QR: ${companyQr ?? 'Server will generate'}');
      print('Image: ${imageFile?.path ?? 'No image'}');

      // Send request
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

  // Updated function for backward compatibility
  Future<CompanyModel> createCompany(Map<String, dynamic> data) async {
    try {
      // Get client ID if not provided in data
      if (!data.containsKey('client_id') || data['client_id'] == null) {
        String? clientId = await getClientId();
        if (clientId == null || clientId.isEmpty) {
          throw Exception('Client ID not found. Please login again.');
        }
        data['client_id'] = clientId;
      }

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