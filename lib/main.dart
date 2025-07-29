import 'package:admin/routes/routes.dart';
import 'package:admin/values/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true, // Tambahan kalau pakai Material 3
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColor.btnijo, // Ganti warna ungu default
            ),
            textTheme: GoogleFonts.nunitoTextTheme(),
          ),
          initialRoute: Routes.splash,
          getPages: Routes.pages,
        );
      },
    );
  }
}
