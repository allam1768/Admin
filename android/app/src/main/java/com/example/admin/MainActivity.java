package com.example.admin; // Sesuaikan dengan package-mu

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import java.io.File;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "scan_media";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("scanFile")) {
                        String path = call.argument("path");
                        scanMediaFile(path);
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void scanMediaFile(String filePath) {
        if (filePath != null) {
            File file = new File(filePath);
            Uri uri = Uri.fromFile(file);
            Intent scanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri);
            sendBroadcast(scanIntent);
        }
    }
}
