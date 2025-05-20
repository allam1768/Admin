import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client_model.dart';

class ClientService {
  static const String baseUrl =
      'https://hamatech.rplrus.com/api/clients';

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
}
