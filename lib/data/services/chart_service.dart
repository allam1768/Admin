import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chart_model.dart';

class ChartService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api';

  static Future<List<ChartModel>> fetchChartData({
    required int companyId,
    required String pestType,
    required String startDate,
    required String endDate,
  }) async {
    try {
      // Validate parameters before making request
      if (companyId <= 0) {
        throw Exception('Invalid company ID: $companyId');
      }

      if (pestType.isEmpty) {
        throw Exception('Pest type cannot be empty');
      }

      if (startDate.isEmpty || endDate.isEmpty) {
        throw Exception('Start date and end date cannot be empty');
      }

      // Build URL with proper encoding
      final uri = Uri.parse('$baseUrl/catches/chart').replace(
        queryParameters: {
          'company_id': companyId.toString(),
          'pest_type': pestType,
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'] ?? [];
          List<ChartModel> chartDataList = data.map((item) => ChartModel.fromJson(item)).toList();
          return chartDataList;
        } else {
          final errorMessage = jsonResponse['message'] ?? 'API returned success: false';
          throw Exception('API Error: $errorMessage');
        }
      } else if (response.statusCode == 422) {
        // Handle validation errors specifically
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          final String errorMessage = errorResponse['message'] ?? 'Validation failed';
          final Map<String, dynamic>? errors = errorResponse['errors'];

          String detailedError = 'Validation Error: $errorMessage';
          if (errors != null) {
            errors.forEach((field, messages) {
              if (messages is List) {
                detailedError += '\n- $field: ${messages.join(', ')}';
              } else {
                detailedError += '\n- $field: $messages';
              }
            });
          }

          throw Exception(detailedError);
        } catch (jsonError) {
          throw Exception('Validation Error (422): ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('API endpoint not found (404). Please check the URL.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error (${response.statusCode}). Please try again later.');
      } else {
        throw Exception('HTTP Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: Please check your internet connection');
    } on FormatException catch (e) {
      throw Exception('Invalid response format from server');
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow; // Re-throw our custom exceptions
      } else {
        throw Exception('Unexpected error: $e');
      }
    }
  }

  // Alternative method to test different pest type formats
  static Future<List<ChartModel>> fetchChartDataWithVariations({
    required int companyId,
    required String pestType,
    required String startDate,
    required String endDate,
  }) async {
    // Try different variations of pest type
    List<String> pestTypeVariations = [
      pestType, // Original
      pestType.toLowerCase(), // lowercase
      pestType.toUpperCase(), // UPPERCASE
      pestType.toLowerCase().replaceAll(' ', '_'), // snake_case
    ];

    Exception? lastException;

    for (String variation in pestTypeVariations) {
      try {
        return await fetchChartData(
          companyId: companyId,
          pestType: variation,
          startDate: startDate,
          endDate: endDate,
        );
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        continue;
      }
    }

    // If all variations failed, throw the last exception
    throw lastException ?? Exception('All pest type variations failed');
  }
}