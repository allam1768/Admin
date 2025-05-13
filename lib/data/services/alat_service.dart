import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../models/alat_model.dart';

class AlatService {
  static const String baseUrl = "https://8821-36-81-11-141.ngrok-free.app/api";

  static Future<http.Response?> createAlat(AlatModel alat, File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/alat'),
      );

      request.fields['nama_alat'] = alat.namaAlat;
      request.fields['lokasi'] = alat.lokasi;
      request.fields['detail_lokasi'] = alat.detail_lokasi;
      request.fields['pest_type'] = alat.pestType;
      request.fields['kondisi'] = alat.kondisi;
      request.fields['kode_qr'] = alat.kodeQr;

      request.files.add(await http.MultipartFile.fromPath('alat_image', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error kirim ke API: $e');
      return null;
    }
  }

  static Future<List<AlatModel>> fetchAlat() async {
    final response = await http.get(Uri.parse('$baseUrl/alat'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List dataList = jsonData['data'];

      return dataList.map((json) => AlatModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data alat (${response.statusCode})');
    }
  }

}
