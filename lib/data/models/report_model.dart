import 'package:shared_preferences/shared_preferences.dart';

class ReportModel {
  final int id;
  final String namaPengirim;
  final String area;
  final String informasi;
  final String? dokumentasi;
  final int companyId;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CompanyModel company;

  ReportModel({
    required this.id,
    required this.namaPengirim,
    required this.area,
    required this.informasi,
    this.dokumentasi,
    required this.companyId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.company,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      namaPengirim: json['nama_pengirim']?.toString() ?? '',
      area: json['area']?.toString() ?? '',
      informasi: json['informasi']?.toString() ?? '',
      dokumentasi: json['dokumentasi']?.toString(),
      companyId: json['company_id'] is int ? json['company_id'] : int.tryParse(json['company_id'].toString()) ?? 0,
      role: json['role']?.toString() ?? 'user',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
      company: CompanyModel.fromJson(json['company'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pengirim': namaPengirim,
      'area': area,
      'informasi': informasi,
      'dokumentasi': dokumentasi,
      'company_id': companyId,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'company': company.toJson(),
    };
  }

  // Helper method untuk mendapatkan tanggal dalam format yang diinginkan
  String get formattedDate {
    return "${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year}";
  }

  // Helper method untuk mendapatkan waktu dalam format yang diinginkan
  String get formattedTime {
    final localTime = createdAt.toLocal();
    return "${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}";
  }

  // Method untuk validasi apakah report ini milik company yang sedang login
  Future<bool> belongsToCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userCompanyId = prefs.getInt('companyid');

      if (userCompanyId == null) {
        print('⚠️ User company ID not found in SharedPreferences');
        return false;
      }

      final belongs = companyId == userCompanyId;
      if (!belongs) {
        print('⚠️ Report ${id} belongs to company ${companyId}, but user is from company ${userCompanyId}');
      }

      return belongs;
    } catch (e) {
      print('❌ Error validating report ownership: $e');
      return false;
    }
  }

  // Static method untuk filter list report berdasarkan company_id user
  static Future<List<ReportModel>> filterByUserCompany(List<ReportModel> reports) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userCompanyId = prefs.getInt('companyid');

      if (userCompanyId == null) {
        print('⚠️ User company ID not found, returning empty list');
        return [];
      }

      final filteredReports = reports.where((report) => report.companyId == userCompanyId).toList();
      print('✅ Filtered ${reports.length} reports to ${filteredReports.length} reports for company $userCompanyId');

      return filteredReports;
    } catch (e) {
      print('❌ Error filtering reports by company: $e');
      return [];
    }
  }

  // Method untuk debug info report
  void debugInfo() {
    print('🐛 === REPORT DEBUG INFO ===');
    print('📄 Report ID: $id');
    print('🏢 Company ID: $companyId');
    print('👤 Sender: $namaPengirim');
    print('📍 Area: $area');
    print('🕐 Created: $formattedDate $formattedTime');
    print('👥 Role: $role');
    print('🏢 Company Name: ${company.name}');
    print('========================');
  }
}

class CompanyModel {
  final int id;
  final int clientId;
  final String name;
  final String companyQr;
  final String address;
  final String phoneNumber;
  final String email;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyModel({
    required this.id,
    required this.clientId,
    required this.name,
    required this.companyQr,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      clientId: json['client_id'] is int ? json['client_id'] : int.tryParse(json['client_id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      companyQr: json['company_qr']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'name': name,
      'company_qr': companyQr,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ReportsResponse {
  final bool success;
  final ReportsData data;
  final String message;

  ReportsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ReportsResponse.fromJson(Map<String, dynamic> json) {
    return ReportsResponse(
      success: json['success'] ?? false,
      data: ReportsData.fromJson(json['data'] ?? {}),
      message: json['message']?.toString() ?? '',
    );
  }
}

class ReportsData {
  final int currentPage;
  final List<ReportModel> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  ReportsData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ReportsData.fromJson(Map<String, dynamic> json) {
    return ReportsData(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page'].toString()) ?? 1,
      data: json['data'] != null
          ? (json['data'] as List)
          .map((item) => ReportModel.fromJson(item))
          .toList()
          : [],
      firstPageUrl: json['first_page_url']?.toString() ?? '',
      from: json['from'] is int
          ? json['from']
          : int.tryParse(json['from'].toString()) ?? 0,
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse(json['last_page'].toString()) ?? 1,
      lastPageUrl: json['last_page_url']?.toString() ?? '',
      nextPageUrl: json['next_page_url']?.toString(),
      path: json['path']?.toString() ?? '',
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page'].toString()) ?? 15,
      prevPageUrl: json['prev_page_url']?.toString(),
      to: json['to'] is int
          ? json['to']
          : int.tryParse(json['to'].toString()) ?? 0,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total'].toString()) ?? 0,
    );
  }

  // Method untuk filter data berdasarkan company_id
  Future<ReportsData> filterByUserCompany() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userCompanyId = prefs.getInt('companyid');

      if (userCompanyId == null) {
        return ReportsData(
          currentPage: currentPage,
          data: [],
          firstPageUrl: firstPageUrl,
          from: from,
          lastPage: lastPage,
          lastPageUrl: lastPageUrl,
          nextPageUrl: nextPageUrl,
          path: path,
          perPage: perPage,
          prevPageUrl: prevPageUrl,
          to: to,
          total: 0,
        );
      }

      final filteredData = data.where((report) => report.companyId == userCompanyId).toList();

      return ReportsData(
        currentPage: currentPage,
        data: filteredData,
        firstPageUrl: firstPageUrl,
        from: from,
        lastPage: lastPage,
        lastPageUrl: lastPageUrl,
        nextPageUrl: nextPageUrl,
        path: path,
        perPage: perPage,
        prevPageUrl: prevPageUrl,
        to: to,
        total: filteredData.length,
      );
    } catch (e) {
      print('❌ Error filtering ReportsData by company: $e');
      return this;
    }
  }
}