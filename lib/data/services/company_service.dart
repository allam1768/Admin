import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../values/config.dart';
import '../models/company_model.dart';

class CompanyService {
  String getImageUrl(String? imagePath) {
    return Config.getImageUrl(imagePath);
  }

  // Function to get token from SharedPreferences
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
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

  // Function to get headers with authorization
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();

    Map<String, String> headers = Map<String, String>.from(Config.commonHeaders);
    headers['ngrok-skip-browser-warning'] = '1';

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('🔑 Using token for authentication: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No token found for authentication');
    }

    return headers;
  }

  // Function to get headers for multipart requests
  Future<Map<String, String>> getMultipartAuthHeaders() async {
    final token = await getToken();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': '1',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('🔑 Using token for multipart authentication: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No token found for multipart authentication');
    }

    return headers;
  }

  Future<List<CompanyModel>> getCompanies() async {
    try {
      final headers = await getAuthHeaders();

      print('📡 Fetching companies from API...');

      final response = await http.get(
        Uri.parse(Config.getApiUrl('/companies')),
        headers: headers,
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> companiesData = responseData['data'];

        print('✅ Successfully fetched ${companiesData.length} companies');
        return companiesData
            .map((json) => CompanyModel.fromJson(json))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau sudah expired');
      } else {
        throw Exception('Failed to load companies: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching companies: $e');
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
        Uri.parse(Config.getApiUrl('/companies')),
      );

      // Add headers with authentication
      final headers = await getMultipartAuthHeaders();
      request.headers.addAll(headers);

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
        print('📷 Image added to request: ${imageFile.path}');
      }

      print('📤 Creating company with authentication...');

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if response has the expected structure
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          print('✅ Company created successfully');
          return CompanyModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response structure');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau sudah expired');
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
      print('❌ Error creating company: $e');
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

      final headers = await getAuthHeaders();

      print('📤 Sending data to API: ${json.encode(data)}');

      final response = await http.post(
        Uri.parse(Config.getApiUrl('/companies')),
        headers: headers,
        body: json.encode(data),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if response has the expected structure
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          print('✅ Company created successfully');
          return CompanyModel.fromJson(responseData['data']);
        } else {
          throw Exception('Invalid response structure');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau sudah expired');
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
      print('❌ Error creating company: $e');
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Network error: Periksa koneksi internet Anda');
      }
      throw Exception('Failed to create company: $e');
    }
  }

  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data) async {
    try {
      final headers = await getAuthHeaders();

      print('🔄 Updating company ID: $id');

      final response = await http.put(
        Uri.parse(Config.getApiUrl('/companies/$id')),
        headers: headers,
        body: json.encode(data),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('✅ Company updated successfully');
        return CompanyModel.fromJson(responseData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau sudah expired');
      } else {
        throw Exception('Failed to update company: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error updating company: $e');
      throw Exception('Failed to update company: $e');
    }
  }

  Future<void> deleteCompany(int id) async {
    try {
      final headers = await getAuthHeaders();

      print('🗑️ Deleting company ID: $id');

      final response = await http.delete(
        Uri.parse(Config.getApiUrl('/companies/$id')),
        headers: headers,
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Company deleted successfully');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token tidak valid atau sudah expired');
      } else {
        throw Exception('Failed to delete company: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting company: $e');
      throw Exception('Failed to delete company: $e');
    }
  }
}