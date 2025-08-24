import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../app/pages/Login screen/login_controller.dart';
import '../../values/config.dart';
import '../models/catch_model.dart';
import 'image_service.dart'; // Import ImageService

class CatchService {
  // Helper method to get the authorization headers for JSON requests
  static Future<Map<String, String>> _getAuthHeaders() async {
    final token = await LoginController.getToken();
    final headers = Map<String, String>.from(Config.commonHeaders);

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Helper method to get the authorization headers for multipart requests
  static Future<Map<String, String>> _getMultipartAuthHeaders() async {
    final token = await LoginController.getToken();
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ========== CREATE OPERATIONS ==========

  /// Create a new catch record with image - WITH IMAGE COMPRESSION
  Future<CatchModel> createCatch(CatchModel catchData) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Config.getApiUrl('/catches')));

      // Add auth headers for multipart request
      request.headers.addAll(await _getMultipartAuthHeaders());

      // Add text fields
      request.fields['alat_id'] = catchData.alatId;
      request.fields['jenis_hama'] = catchData.jenisHama;
      request.fields['jumlah'] = catchData.jumlah.toString();
      request.fields['tanggal'] = catchData.tanggal;
      request.fields['dicatat_oleh'] = catchData.dicatatOleh;
      request.fields['kondisi'] = catchData.kondisi;
      request.fields['catatan'] = catchData.catatan;

      // Compress and add image file
      File originalImageFile = File(catchData.fotoDokumentasi);

      if (await originalImageFile.exists()) {
        print('Original catch image size: ${await originalImageFile.length()} bytes');

        // Compress image using ImageService
        final compressResult = await ImageService.compressToMax2MB(originalImageFile);

        File? finalImageFile;
        if (compressResult is File) {
          finalImageFile = compressResult;
          print('Catch image compressed successfully. New size: ${await finalImageFile.length()} bytes');
        } else {
          print('Catch image compression failed, using original image');
          finalImageFile = originalImageFile;
        }

        // Check if image is under limit
        if (await ImageService.isUnderLimit(finalImageFile)) {
          var imageFile = await http.MultipartFile.fromPath(
            'foto_dokumentasi',
            finalImageFile.path,
          );
          request.files.add(imageFile);
        } else {
          throw Exception('Image is too large even after compression. Please use a smaller image.');
        }
      } else {
        throw Exception('Image file not found: ${catchData.fotoDokumentasi}');
      }

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

  /// Fetch all catches data (for list view) - UPDATED with better image handling and token
  static Future<List<Map<String, dynamic>>> fetchCatchesData() async {
    try {
      final headers = await _getAuthHeaders(); // Use auth headers
      final response = await http.get(
        Uri.parse(Config.getApiUrl('/catches')),
        headers: headers,
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

  /// Fetch detailed catch data by ID - UPDATED with token
  static Future<Map<String, dynamic>> fetchCatchDetail(int id) async {
    try {
      final headers = await _getAuthHeaders(); // Use auth headers
      final response = await http.get(
        Uri.parse(Config.getApiUrl('/catches/$id')),
        headers: headers,
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

  /// Update a catch record (text fields only) with token
  static Future<Map<String, dynamic>> updateCatch(
      int id,
      Map<String, dynamic> updateData,
      ) async {
    try {
      final headers = await _getAuthHeaders(); // Use auth headers
      final response = await http.put(
        Uri.parse(Config.getApiUrl('/catches/$id')),
        headers: headers,
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

  /// Update catch with multipart data (including image) with token - WITH IMAGE COMPRESSION
  static Future<Map<String, dynamic>> updateCatchWithImage(
      int id,
      Map<String, String> fields,
      String? imagePath,
      ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Config.getApiUrl('/catches/$id')),
      );

      // Add auth headers for multipart request
      request.headers.addAll(await _getMultipartAuthHeaders());

      request.fields['_method'] = 'PUT';
      request.fields.addAll(fields);

      // Compress and add image if provided
      if (imagePath != null && imagePath.isNotEmpty) {
        File originalImageFile = File(imagePath);

        if (await originalImageFile.exists()) {
          print('Original update image size: ${await originalImageFile.length()} bytes');

          // Compress image using ImageService
          final compressResult = await ImageService.compressToMax2MB(originalImageFile);

          File? finalImageFile;
          if (compressResult is File) {
            finalImageFile = compressResult;
            print('Update image compressed successfully. New size: ${await finalImageFile.length()} bytes');
          } else {
            print('Update image compression failed, using original image');
            finalImageFile = originalImageFile;
          }

          // Check if image is under limit
          if (await ImageService.isUnderLimit(finalImageFile)) {
            var imageFile = await http.MultipartFile.fromPath(
              'foto_dokumentasi',
              finalImageFile.path,
            );
            request.files.add(imageFile);
          } else {
            throw Exception('Image is too large even after compression. Please use a smaller image.');
          }
        } else {
          throw Exception('Image file not found: $imagePath');
        }
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

  /// Delete a catch record by ID with token
  static Future<bool> deleteCatch(int id) async {
    try {
      final headers = await _getAuthHeaders(); // Use auth headers
      final response = await http.delete(
        Uri.parse(Config.getApiUrl('/catches/$id')),
        headers: headers,
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

  // ========== HELPER METHODS - UPDATED (No auth needed for helpers) ==========

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

  // ========== EDIT VALIDATION METHODS (No auth needed for these client-side checks) ==========

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