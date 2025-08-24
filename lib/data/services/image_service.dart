import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  static const int maxBytes = 2 * 1024 * 1024; // 2 MB
  static const int _minQuality = 10; // biar lebih fleksibel
  static const int _qualityStep = 10;

  /// Kompres adaptif sampai <= 2MB.
  static Future<Object?> compressToMax2MB(
      File file, {
        int startQuality = 85,
        double minScale = 0.2, // izinkan lebih kecil dari 50%
      }) async {
    try {
      if (await file.length() <= maxBytes) return file;

      final tempDir = await getTemporaryDirectory();
      String _tempPath() =>
          "${tempDir.path}/img_${DateTime.now().microsecondsSinceEpoch}.jpg";

      double scale = 1.0;
      File? bestResult; // simpan hasil terbaik walau >2MB

      while (scale >= minScale) {
        int q = startQuality;
        while (q >= _minQuality) {
          final outPath = _tempPath();
          final result = await FlutterImageCompress.compressAndGetFile(
            file.path,
            outPath,
            quality: q,
            format: CompressFormat.jpeg,
            keepExif: false,
            minWidth: (4000 * scale).toInt(),
            minHeight: (4000 * scale).toInt(),
          );

          if (result == null) {
            q -= _qualityStep;
            continue;
          }

          final bytes = await result.length();

          // simpan hasil terbaik walau > 2MB
          if (bestResult == null || bytes < await bestResult.length()) {
            bestResult = result as File?;
          }

          if (bytes <= maxBytes) {
            return result; // sukses: ≤ 2 MB
          }

          q -= _qualityStep;
        }
        scale -= 0.15;
      }

      // fallback: hasil terkecil yang ada, meskipun > 2MB
      return bestResult;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isUnderLimit(File file) async {
    return (await file.length()) <= maxBytes;
  }
}
