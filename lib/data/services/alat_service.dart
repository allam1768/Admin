// alat_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import '../models/alat_model.dart';

class AlatService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api';

  static Future<http.Response?> createAlat(AlatModel alat, File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/alat'),
      );

      request.fields['nama_alat'] = alat.namaAlat;
      request.fields['lokasi'] = alat.lokasi;
      request.fields['detail_lokasi'] = alat.detailLokasi;
      request.fields['pest_type'] = alat.pestType;
      request.fields['kondisi'] = alat.kondisi;
      request.fields['kode_qr'] = alat.kodeQr;

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('alat_image', imageFile.path),
        );
      }

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

  // Modified fetchAlat to accept optional companyId parameter
  static Future<List<AlatModel>> fetchAlat({int? companyId}) async {
    String url = '$baseUrl/alat';

    // Add company_id parameter if provided
    if (companyId != null) {
      url += '?company_id=$companyId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'ngrok-skip-browser-warning': '1',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List dataList = jsonData['data'];

      return dataList.map((json) => AlatModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data alat (${response.statusCode})');
    }
  }

  // New method specifically for fetching alat by company
  static Future<List<AlatModel>> fetchAlatByCompany(int companyId) async {
    return await fetchAlat(companyId: companyId);
  }

  static Future<http.Response?> deleteAlat(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/alat/$id'),
        headers: {
          'ngrok-skip-browser-warning': '1',
        },
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error saat menghapus alat: $e');
      return null;
    }
  }

  static Future<http.Response?> updateAlat(int id, AlatModel alat, {File? imageFile}) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/alat/$id'),
      );

      request.fields['nama_alat'] = alat.namaAlat;
      request.fields['lokasi'] = alat.lokasi;
      request.fields['detail_lokasi'] = alat.detailLokasi;
      request.fields['pest_type'] = alat.pestType;
      request.fields['kondisi'] = alat.kondisi;
      request.fields['kode_qr'] = alat.kodeQr;
      request.fields['_method'] = 'PUT';

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('alat_image', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error update ke API: $e');
      return null;
    }
  }

  static Future<http.Response?> getAlatById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alat/$id'),
        headers: {
          'ngrok-skip-browser-warning': '1',
        },
      );

      print('Status getAlatById: ${response.statusCode}');
      print('Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error getAlatById: $e');
      return null;
    }
  }
}