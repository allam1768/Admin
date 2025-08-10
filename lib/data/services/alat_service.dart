import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../values/config.dart';
import '../models/alat_model.dart';

class AlatService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    final headers = Map<String, String>.from(Config.commonHeaders);

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<http.Response?> createAlat(AlatModel alat, File imageFile) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Config.getApiUrl('/alat')),
      );

      // Add Bearer token to headers
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['ngrok-skip-browser-warning'] = '1';

      request.fields['nama_alat'] = alat.namaAlat;
      request.fields['lokasi'] = alat.lokasi;
      request.fields['detail_lokasi'] = alat.detailLokasi;
      request.fields['pest_type'] = alat.pestType;
      request.fields['kondisi'] = alat.kondisi;
      request.fields['kode_qr'] = alat.kodeQr;

      // Add company_id field if it exists
      if (alat.companyId != null) {
        request.fields['company_id'] = alat.companyId.toString();
      }

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

  // Modified fetchAlat to accept optional companyId parameter and use Bearer token
  static Future<List<AlatModel>> fetchAlat({int? companyId}) async {
    String url = Config.getApiUrl('/alat');

    // Add company_id parameter if provided
    if (companyId != null) {
      url += '?company_id=$companyId';
    }

    final headers = await _getHeaders();

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print('Fetch Alat - Status: ${response.statusCode}');
    print('Fetch Alat - Headers: $headers');
    print('Fetch Alat - Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List dataList = jsonData['data'];

      return dataList.map((json) => AlatModel.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('Token tidak valid atau sudah kadaluarsa (401)');
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
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse(Config.getApiUrl('/alat/$id')),
        headers: headers,
      );

      print('Delete Alat - Status: ${response.statusCode}');
      print('Delete Alat - Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error saat menghapus alat: $e');
      return null;
    }
  }

  static Future<http.Response?> updateAlat(int id, AlatModel alat, {File? imageFile}) async {
    try {
      final token = await _getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Config.getApiUrl('/alat/$id')),
      );

      // Add Bearer token to headers
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['ngrok-skip-browser-warning'] = '1';

      request.fields['nama_alat'] = alat.namaAlat;
      request.fields['lokasi'] = alat.lokasi;
      request.fields['detail_lokasi'] = alat.detailLokasi;
      request.fields['pest_type'] = alat.pestType;
      request.fields['kondisi'] = alat.kondisi;
      request.fields['kode_qr'] = alat.kodeQr;
      request.fields['_method'] = 'PUT';

      // Add company_id field if it exists
      if (alat.companyId != null) {
        request.fields['company_id'] = alat.companyId.toString();
      }

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('alat_image', imageFile.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Update Alat - Status: ${response.statusCode}');
      print('Update Alat - Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error update ke API: $e');
      return null;
    }
  }

  static Future<http.Response?> getAlatById(int id) async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse(Config.getApiUrl('/alat/$id')),
        headers: headers,
      );

      print('Get Alat By ID - Status: ${response.statusCode}');
      print('Get Alat By ID - Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error getAlatById: $e');
      return null;
    }
  }

  // Method untuk mengecek apakah token masih valid
  static Future<bool> checkTokenValidity() async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse(Config.getApiUrl('/user/profile')), // endpoint untuk cek token
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error checking token validity: $e');
      return false;
    }
  }
}