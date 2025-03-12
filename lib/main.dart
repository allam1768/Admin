import 'package:admin/pages/Bottom%20Nav/home_binding.dart';
import 'package:admin/pages/Bottom%20Nav/home_view.dart';
import 'package:admin/pages/Data%20Company%20Screen/data_Company_view.dart';
import 'package:admin/pages/Data%20Company%20Screen/data_company_binding.dart';
import 'package:admin/pages/Login%20Screen/login_screen_binding.dart';
import 'package:admin/pages/Login%20Screen/login_screen_view.dart';
import 'package:admin/pages/Splash%20Screen/spalsh_screen_binding.dart';
import 'package:admin/pages/Splash%20Screen/spalsh_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
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
      splitScreenMode: false,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.nunitoTextTheme(),
          ),
          initialRoute: '/home',
          getPages: [
            GetPage(
              name: '/splash',
              page: () => SplashScreenView(),
              binding: SplashScreenBinding(),
            ),
            GetPage(
              name: '/login',
              page: () => LoginScreenView(),
              binding: LoginScreenBinding(),
            ),
            GetPage(
              name: '/home',
              page: () => HomeView(),
              binding: HomeBinding(),
            ),
            GetPage(
              name: '/DataCompany',
              page: () => DataCompanyView(),
              binding: DataCompanyBinding(),
            ),
          ],
        );
      },
    );
  }
}
