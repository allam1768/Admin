import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/worker_model.dart';

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
}