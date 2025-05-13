import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client_model.dart';

class ClientService {
  static const String baseUrl =
      'https://cb5b-36-65-191-209.ngrok-free.app/api/clients';

  static Future<List<ClientModel>> fetchClients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List rawList = data['data'];
      return rawList.map((e) => ClientModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch clients (${response.statusCode})');
    }
  }
}
