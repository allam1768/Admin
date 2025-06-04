import 'dart:convert';
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

  Future<CompanyModel> createCompany(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/companies'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return CompanyModel.fromJson(responseData['data']);
      } else {
        throw Exception('Failed to create company: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create company: $e');
    }
  }
}
