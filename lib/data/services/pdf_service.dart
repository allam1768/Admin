import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  final Dio _dio = Dio();

  Future<File?> downloadPdf({
    required int companyId,
    required String startDate,
    required String endDate,
    String useDate = "created_at",
  }) async {
    try {
      final response = await _dio.get(
        "https://hamatech.rplrus.com/api/export-pdf",
        queryParameters: {
          "company_id": companyId,
          "start_date": startDate,
          "end_date": endDate,
          "use_date": useDate,
        },
        options: Options(
          responseType: ResponseType.bytes, // penting biar dapat PDF, bukan JSON
        ),
      );

      // simpan file ke direktori aplikasi
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          "${dir.path}/report_${companyId}_$startDate-$endDate.pdf";
      final file = File(filePath);
      await file.writeAsBytes(response.data);

      return file;
    } catch (e) {
      print("Error download PDF: $e");
      return null;
    }
  }

  Future<void> openPdf(File file) async {
    await OpenFilex.open(file.path);
  }
}
