import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import '../../Bottom Nav/bottomnav_controller.dart';

class QrCompanyController extends GetxController {
  final GlobalKey globalKey = GlobalKey();

  void goToDashboard() {
    Get.find<BottomNavController>().selectedIndex.value = 1;
    Get.offNamed('/bottomnav'); // Ganti dengan nama screen yang ada bottom nav-nya
  }


  Future<void> saveQrImage() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

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

      String qrFolderPath = "$newPath/Pictures/QR Company";
      Directory qrFolder = Directory(qrFolderPath);
      if (!qrFolder.existsSync()) {
        qrFolder.createSync(recursive: true);
      }

      String qrHash = generateHash(pngBytes);

      if (isDuplicate(qrFolder, qrHash)) {
        showCustomSnackbar("QR Code sudah ada!", null);
        return;
      }

      String fileName = "company_qr_${DateTime.now().millisecondsSinceEpoch}.png";
      String savePath = "$qrFolderPath/$fileName";

      File file = File(savePath);
      await file.writeAsBytes(pngBytes);

      await scanFile(savePath);

      showCustomSnackbar("QR Code berhasil disimpan!", savePath);
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

  void showCustomSnackbar(String message, String? filePath) {
    Get.rawSnackbar(
      messageText: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.info, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              filePath == null ? message : "$message\nLokasi: $filePath",
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0.7),
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 0),
    );
  }

  String generateHash(Uint8List data) {
    return sha256.convert(data).toString();
  }

  bool isDuplicate(Directory directory, String newHash) {
    List<FileSystemEntity> files = directory.listSync();
    for (var file in files) {
      if (file is File) {
        Uint8List fileBytes = file.readAsBytesSync();
        String fileHash = generateHash(fileBytes);
        if (fileHash == newHash) {
          return true;
        }
      }
    }
    return false;
  }
}
