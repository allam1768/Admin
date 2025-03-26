import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class QrController extends GetxController {
  final GlobalKey globalKey = GlobalKey();

  void saveQr() {
    saveQrImage();
  }

  Future<void> saveQrImage() async {
    try {
      // Render QR ke gambar
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Dapatkan direktori penyimpanan
      Directory? directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> paths = directory!.path.split("/");

      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/$folder";
        } else {
          break;
        }
      }

      // Buat folder "QR Hamatech" di dalam Pictures
      String qrFolderPath = "$newPath/Pictures/QR Hamatech";
      Directory qrFolder = Directory(qrFolderPath);
      if (!qrFolder.existsSync()) {
        qrFolder.createSync(recursive: true);
      }

      // Simpan file dengan nama unik
      String fileName = "qrcode_${DateTime.now().millisecondsSinceEpoch}.jpg";
      String savePath = "$qrFolderPath/$fileName";

      File file = File(savePath);
      await file.writeAsBytes(pngBytes);

      // Scan file agar muncul di galeri
      await scanFile(savePath);

      print("QR Code berhasil disimpan di: $savePath");
    } catch (e) {
      print("Error saving QR image: $e");
    }
  }

  Future<void> scanFile(String filePath) async {
    try {
      await const MethodChannel('scan_media')
          .invokeMethod('scanFile', {"path": filePath});
    } catch (e) {
      print("Error scanning file: $e");
    }
  }
}
