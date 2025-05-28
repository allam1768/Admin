import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/catch_model.dart';

class CatchService {
  static const String baseUrl = 'https://hamatech.rplrus.com/api';
  static const String storageUrl = 'https://hamatech.rplrus.com/storage';

  // ========== CREATE OPERATIONS ==========

  /// Create a new catch record with image
  Future<CatchModel> createCatch(CatchModel catchData) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/catches'));

      // Add text fields
      request.fields['alat_id'] = catchData.alatId;
      request.fields['jenis_hama'] = catchData.jenisHama;
      request.fields['jumlah'] = catchData.jumlah.toString();
      request.fields['tanggal'] = catchData.tanggal;
      request.fields['dicatat_oleh'] = catchData.dicatatOleh;
      request.fields['kondisi'] = catchData.kondisi;
      request.fields['catatan'] = catchData.catatan;

      // Add image file
      var imageFile = await http.MultipartFile.fromPath(
        'foto_dokumentasi',
        catchData.fotoDokumentasi,
      );
      request.files.add(imageFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return CatchModel.fromJson(responseData['data']);
      } else {
        print('Response body: ${response.body}');
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(
            'Failed to create catch record: ${response.statusCode}\nError: ${errorData['message'] ?? errorData}');
      }
    } catch (e) {
      throw Exception('Error creating catch record: $e');
    }
  }

  // ========== READ OPERATIONS ==========

  /// Fetch all catches data (for list view) - UPDATED with better image handling
  static Future<List<Map<String, dynamic>>> fetchCatchesData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/catches'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> catchesData = responseData['data']['data'];

        return catchesData.map<Map<String, dynamic>>((item) {
          // Format tanggal dan waktu
          DateTime parsedDate = DateTime.parse(item['tanggal']);
          String formattedDate = "${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}";

          DateTime createdAt = DateTime.parse(item['created_at']);
          String formattedTime = "${createdAt.hour.toString().padLeft(2, '0')}.${createdAt.minute.toString().padLeft(2, '0')}";

          // IMPROVED: Use CatchModel's image processing
          String imageUrl = CatchModel.getDisplayImageUrl(item['foto_dokumentasi']);

          return {
            "id": item['id'],
            "name": item['alat']['nama_alat'],
            "date": formattedDate,
            "time": formattedTime,
            "created_at": item['created_at'],
            "alat_id": item['alat_id'].toString(),
            "jenis_hama": item['jenis_hama'],
            "jumlah": item['jumlah'],
            "dicatat_oleh": item['dicatat_oleh'],
            "kondisi": item['kondisi'],
            "catatan": item['catatan'],
            "foto_dokumentasi": item['foto_dokumentasi'], // Original path
            "image_url": imageUrl, // Processed URL
            "lokasi": item['alat']['lokasi'],
            "detail_lokasi": item['alat']['detail_lokasi'],
            "kode_qr": item['alat']['kode_qr'],
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching catches data: $e');
    }
  }

  /// Fetch detailed catch data by ID - UPDATED
  static Future<Map<String, dynamic>> fetchCatchDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/catches/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        // Add processed image URL to the response
        data['image_url'] = CatchModel.getDisplayImageUrl(data['foto_dokumentasi']);

        return data;
      } else {
        throw Exception('Failed to fetch catch detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching catch detail: $e');
    }
  }

  // ========== UPDATE OPERATIONS ==========

  /// Update a catch record (text fields only)
  static Future<Map<String, dynamic>> updateCatch(
      int id,
      Map<String, dynamic> updateData,
      ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/catches/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        // Add processed image URL
        data['image_url'] = CatchModel.getDisplayImageUrl(data['foto_dokumentasi']);

        return data;
      } else {
        throw Exception('Failed to update catch: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating catch: $e');
    }
  }

  /// Update catch with multipart data (including image)
  static Future<Map<String, dynamic>> updateCatchWithImage(
      int id,
      Map<String, String> fields,
      String? imagePath,
      ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/catches/$id'),
      );

      request.fields['_method'] = 'PUT';
      request.fields.addAll(fields);

      if (imagePath != null && imagePath.isNotEmpty) {
        var imageFile = await http.MultipartFile.fromPath(
          'foto_dokumentasi',
          imagePath,
        );
        request.files.add(imageFile);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'];

        // Add processed image URL
        data['image_url'] = CatchModel.getDisplayImageUrl(data['foto_dokumentasi']);

        return data;
      } else {
        throw Exception('Failed to update catch with image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating catch with image: $e');
    }
  }

  // ========== DELETE OPERATIONS ==========

  /// Delete a catch record by ID
  static Future<bool> deleteCatch(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/catches/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete catch: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting catch: $e');
    }
  }

  // ========== HELPER METHODS - UPDATED ==========

  /// Helper method to format image URL - DEPRECATED, use CatchModel.getDisplayImageUrl instead
  @deprecated
  static String getFullImageUrl(String imagePath) {
    return CatchModel.getDisplayImageUrl(imagePath);
  }

  /// Helper method to format condition text
  static String formatCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'good':
        return 'Baik';
      case 'broken':
        return 'Rusak';
      case 'maintenance':
        return 'Maintenance';
      default:
        return condition;
    }
  }

  /// Helper method to format date and time
  static Map<String, String> formatDateTime(String dateStr, String createdAtStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      DateTime createdAt = DateTime.parse(createdAtStr);

      String formattedDate = "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
      String formattedTime = "${createdAt.hour.toString().padLeft(2, '0')}.${createdAt.minute.toString().padLeft(2, '0')}";

      return {
        'date': formattedDate,
        'time': formattedTime,
        'dateTime': "$formattedDate   $formattedTime",
      };
    } catch (e) {
      return {
        'date': dateStr,
        'time': 'N/A',
        'dateTime': "$dateStr   N/A",
      };
    }
  }

  // ========== EDIT VALIDATION METHODS ==========

  static bool canEditRecord(String dateTimeString) {
    try {
      List<String> parts = dateTimeString.split('   ');
      if (parts.length != 2) return false;

      String datePart = parts[0];
      String timePart = parts[1];

      List<String> dateParts = datePart.split('.');
      if (dateParts.length != 3) return false;

      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      List<String> timeParts = timePart.split('.');
      if (timeParts.length != 2) return false;

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      DateTime recordTime = DateTime(year, month, day, hour, minute);
      DateTime now = DateTime.now();

      Duration difference = now.difference(recordTime);
      return difference.inHours < 4;

    } catch (e) {
      print('Error parsing datetime for edit check: $e');
      return false;
    }
  }

  static bool canEditRecordFromDateTime(DateTime createdAt) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);
    return difference.inHours < 4;
  }

  static String getRemainingEditTime(DateTime createdAt) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);

    if (difference.inHours >= 4) {
      return "Edit time expired";
    }

    Duration remaining = Duration(hours: 4) - difference;
    int hours = remaining.inHours;
    int minutes = remaining.inMinutes % 60;

    return "${hours}h ${minutes}m remaining";
  }

  static String getRemainingEditTimeFromString(String dateTimeString) {
    try {
      List<String> parts = dateTimeString.split('   ');
      if (parts.length != 2) return "Invalid format";

      String datePart = parts[0];
      String timePart = parts[1];

      List<String> dateParts = datePart.split('.');
      if (dateParts.length != 3) return "Invalid date format";

      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      List<String> timeParts = timePart.split('.');
      if (timeParts.length != 2) return "Invalid time format";

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      DateTime recordTime = DateTime(year, month, day, hour, minute);

      return getRemainingEditTime(recordTime);

    } catch (e) {
      return "Error calculating time";
    }
  }

  static Map<String, dynamic> getEditStatus(DateTime createdAt) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(createdAt);
    bool canEdit = difference.inHours < 4;

    Map<String, dynamic> status = {
      'canEdit': canEdit,
      'timeElapsed': difference,
      'remainingTime': canEdit ? getRemainingEditTime(createdAt) : 'Edit time expired',
    };

    return status;
  }

  static bool validateCatchData(Map<String, dynamic> data) {
    List<String> requiredFields = [
      'alat_id',
      'jenis_hama',
      'jumlah',
      'tanggal',
      'dicatat_oleh',
      'kondisi'
    ];

    for (String field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null || data[field].toString().isEmpty) {
        return false;
      }
    }
    return true;
  }

  static List<String> getConditionOptions() {
    return ['good', 'broken', 'maintenance'];
  }

  static List<Map<String, String>> getFormattedConditionOptions() {
    return [
      {'value': 'good', 'label': 'Baik'},
      {'value': 'broken', 'label': 'Rusak'},
      {'value': 'maintenance', 'label': 'Maintenance'},
    ];
  }
}