import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../values/config.dart';
import '../models/report_model.dart';
import 'image_service.dart'; // Import ImageService

class ReportService {
  // Get token dari SharedPreferences
  Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get headers
  Future<Map<String, String>> get headers async {
    final tokenValue = await token;
    return {
      ...Config.commonHeaders, // Use common headers from config
      if (tokenValue != null) 'Authorization': 'Bearer $tokenValue',
    };
  }

  // Get data user dari SharedPreferences (kecuali role yang di-hardcode)
  Future<Map<String, dynamic>> get userData async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'company_id': prefs.getInt('companyid'),
      'role': 'admin', // ⛔ Hardcoded role
      'nama_pengirim': prefs.getString('nama') ?? prefs.getString('username') ?? 'User',
    };
  }

  // GET laporan - WAJIB filter berdasarkan company_id
  Future<ReportsResponse> getReports({int page = 1}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getInt('companyid');

      // WAJIB ada company_id
      if (companyId == null) {
        throw Exception('Company ID not found in SharedPreferences. Please re-login.');
      }

      // Selalu sertakan company_id dalam query parameter
      String endpoint = Config.getApiUrl('/reports?page=$page&company_id=$companyId');

      print('🌐 Making request to: $endpoint');

      final url = Uri.parse(endpoint);
      final requestHeaders = await headers;

      print('📋 Headers: $requestHeaders');
      print('🏢 Filtering by Company ID: $companyId');

      final response = await http.get(
        url,
        headers: requestHeaders,
      ).timeout(Config.requestTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) throw Exception('Empty response from server');
        final jsonData = json.decode(response.body);
        if (jsonData == null) throw Exception('Invalid JSON response');

        final reportsResponse = ReportsResponse.fromJson(jsonData);

        // Double check: Filter lagi di client side untuk keamanan tambahan
        final filteredReports = reportsResponse.data.data
            .where((report) => report.companyId == companyId)
            .toList();

        // Create new ReportsData with filtered reports
        final filteredData = ReportsData(
          currentPage: reportsResponse.data.currentPage,
          data: filteredReports,
          firstPageUrl: reportsResponse.data.firstPageUrl,
          from: reportsResponse.data.from,
          lastPage: reportsResponse.data.lastPage,
          lastPageUrl: reportsResponse.data.lastPageUrl,
          nextPageUrl: reportsResponse.data.nextPageUrl,
          path: reportsResponse.data.path,
          perPage: reportsResponse.data.perPage,
          prevPageUrl: reportsResponse.data.prevPageUrl,
          to: reportsResponse.data.to,
          total: filteredReports.length,
        );

        print('✅ Filtered reports count: ${filteredReports.length}');

        return ReportsResponse(
          success: reportsResponse.success,
          data: filteredData,
          message: reportsResponse.message,
        );
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token invalid or expired');
      } else {
        print('❌ Error response body: ${response.body}');
        throw Exception('Failed to load reports: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in getReports: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // GET laporan by company ID - Metode utama untuk filter berdasarkan company
  Future<ReportsResponse> getReportsByCompany(int companyId, {int page = 1}) async {
    try {
      final url = Uri.parse(Config.getApiUrl('/reports?page=$page&company_id=$companyId'));
      final requestHeaders = await headers;

      print('🌐 Making company-filtered request to: $url');
      print('🏢 Company ID filter: $companyId');

      final response = await http.get(
        url,
        headers: requestHeaders,
      ).timeout(Config.requestTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) throw Exception('Empty response from server');
        final jsonData = json.decode(response.body);
        if (jsonData == null) throw Exception('Invalid JSON response');

        final reportsResponse = ReportsResponse.fromJson(jsonData);

        // Double check: Filter lagi di client side untuk keamanan tambahan
        final filteredReports = reportsResponse.data.data
            .where((report) => report.companyId == companyId)
            .toList();

        print('✅ Company filtered reports count: ${filteredReports.length}');

        // Create new ReportsData with filtered reports
        final filteredData = ReportsData(
          currentPage: reportsResponse.data.currentPage,
          data: filteredReports,
          firstPageUrl: reportsResponse.data.firstPageUrl,
          from: reportsResponse.data.from,
          lastPage: reportsResponse.data.lastPage,
          lastPageUrl: reportsResponse.data.lastPageUrl,
          nextPageUrl: reportsResponse.data.nextPageUrl,
          path: reportsResponse.data.path,
          perPage: reportsResponse.data.perPage,
          prevPageUrl: reportsResponse.data.prevPageUrl,
          to: reportsResponse.data.to,
          total: filteredReports.length,
        );

        return ReportsResponse(
          success: reportsResponse.success,
          data: filteredData,
          message: reportsResponse.message,
        );
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token invalid or expired');
      } else {
        throw Exception('Failed to load reports: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in getReportsByCompany: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  // GET laporan by ID - dengan validasi company_id
  Future<ReportModel> getReportById(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userCompanyId = prefs.getInt('companyid');

      final url = Uri.parse(Config.getApiUrl('/reports/$id'));
      final requestHeaders = await headers;

      final response = await http.get(
        url,
        headers: requestHeaders,
      ).timeout(Config.requestTimeout);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) throw Exception('Empty response from server');
        final jsonData = json.decode(response.body);
        if (jsonData == null || jsonData['data'] == null) throw Exception('Invalid response structure');

        final report = ReportModel.fromJson(jsonData['data']);

        // Validasi company_id untuk keamanan
        if (userCompanyId != null && report.companyId != userCompanyId) {
          throw Exception('Access denied: Report does not belong to your company');
        }

        return report;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token invalid or expired');
      } else {
        throw Exception('Failed to load report detail: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // POST laporan dengan gambar (Multipart) - WAJIB validasi company_id - WITH IMAGE COMPRESSION
  Future<ReportModel> createReportWithImage({
    required String area,
    required String informasi,
    File? imageFile,
    String? namaPengirim,
    int? companyId,
    String? role,
  }) async {
    try {
      final url = Uri.parse(Config.getApiUrl('/reports'));
      final tokenValue = await token;
      final user = await userData;

      final finalNamaPengirim = namaPengirim ?? user['nama_pengirim'] ?? 'Unknown';
      final finalCompanyId = companyId ?? user['company_id'];
      final finalRole = 'admin'; // ⛔ Hardcoded role

      if (finalCompanyId == null) {
        throw Exception('Company ID is required. Please ensure you have selected a company.');
      }

      var request = http.MultipartRequest('POST', url);

      if (tokenValue != null) {
        request.headers['Authorization'] = 'Bearer $tokenValue';
      }
      request.headers['Accept'] = 'application/json';

      request.fields['nama_pengirim'] = finalNamaPengirim;
      request.fields['area'] = area;
      request.fields['informasi'] = informasi;
      request.fields['company_id'] = finalCompanyId.toString();
      request.fields['role'] = finalRole;

      print('📤 Creating report for Company ID: $finalCompanyId');

      if (imageFile != null && await imageFile.exists()) {
        print('🖼️ Original image size: ${await imageFile.length()} bytes');

        // Compress image using ImageService
        final compressResult = await ImageService.compressToMax2MB(imageFile);

        File? finalImageFile;
        if (compressResult is File) {
          finalImageFile = compressResult;
          print('✅ Image compressed successfully. New size: ${await finalImageFile.length()} bytes');
        } else {
          print('❌ Image compression failed, using original image');
          finalImageFile = imageFile;
        }

        // Check if image is under limit
        if (await ImageService.isUnderLimit(finalImageFile)) {
          var imageStream = http.ByteStream(finalImageFile.openRead());
          var imageLength = await finalImageFile.length();
          var multipartFile = http.MultipartFile(
            'dokumentasi',
            imageStream,
            imageLength,
            filename: 'report_image.jpg',
          );
          request.files.add(multipartFile);
        } else {
          throw Exception('Image is too large even after compression. Please use a smaller image.');
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) throw Exception('Empty response from server');
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final createdReport = ReportModel.fromJson(jsonData['data']);

          // Validasi company_id response
          if (createdReport.companyId != finalCompanyId) {
            throw Exception('Report created with wrong company ID');
          }

          print('✅ Report created successfully for Company ID: ${createdReport.companyId}');
          return createdReport;
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to create report');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token invalid or expired');
      } else {
        throw Exception('Failed to create report: HTTP ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // POST laporan tanpa gambar - WAJIB validasi company_id
  Future<ReportModel> createReport({
    String? namaPengirim,
    required String area,
    required String informasi,
    String? dokumentasi,
    int? companyId,
    String? role,
  }) async {
    try {
      final url = Uri.parse(Config.getApiUrl('/reports'));
      final requestHeaders = await headers;
      final user = await userData;

      final finalNamaPengirim = namaPengirim ?? user['nama_pengirim'] ?? 'Unknown';
      final finalCompanyId = companyId ?? user['company_id'];
      final finalRole = 'admin'; // ⛔ Hardcoded role

      if (finalCompanyId == null) {
        throw Exception('Company ID is required. Please ensure you have selected a company.');
      }

      final body = json.encode({
        'nama_pengirim': finalNamaPengirim,
        'area': area,
        'informasi': informasi,
        'dokumentasi': dokumentasi,
        'company_id': finalCompanyId,
        'role': finalRole,
      });

      print('📤 Creating report for Company ID: $finalCompanyId');

      final response = await http.post(
        url,
        headers: requestHeaders,
        body: body,
      ).timeout(Config.requestTimeout);

      if (response.statusCode == 201) {
        if (response.body.isEmpty) throw Exception('Empty response from server');
        final jsonData = json.decode(response.body);
        if (jsonData['data'] != null) {
          final createdReport = ReportModel.fromJson(jsonData['data']);

          // Validasi company_id response
          if (createdReport.companyId != finalCompanyId) {
            throw Exception('Report created with wrong company ID');
          }

          print('✅ Report created successfully for Company ID: ${createdReport.companyId}');
          return createdReport;
        } else {
          throw Exception('Invalid response structure');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Token invalid or expired');
      } else {
        throw Exception('Failed to create report: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Method untuk debug company_id dari SharedPreferences
  Future<void> debugCompanyId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getInt('companyid');
      print('🛠 === COMPANY ID DEBUG ===');
      print('🏢 Current Company ID: $companyId');
      print('📝 Type: ${companyId.runtimeType}');
      print('✅ Is Valid: ${companyId != null && companyId > 0}');
      print('========================');
    } catch (e) {
      print('❌ Error debugging company ID: $e');
    }
  }
}