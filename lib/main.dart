
import 'package:admin/app/pages/Account%20Client/account_client_binding.dart';
import 'package:admin/app/pages/Account%20Client/account_client_view.dart';
import 'package:admin/app/pages/Detail%20Data%20Screen/detail_data_binding.dart';
import 'package:admin/app/pages/Detail%20Data%20Screen/detail_data_view.dart';
import 'package:admin/app/pages/Detail%20History%20Screen/detail_binding.dart';
import 'package:admin/app/pages/Detail%20History%20Screen/detail_view.dart';
import 'package:admin/app/pages/Edit%20Data%20History%20Screen/edit_data_binding.dart';
import 'package:admin/app/pages/Edit%20Data%20History%20Screen/edit_data_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/pages/Account Worker/account_worker_binding.dart';
import 'app/pages/Account Worker/account_worker_view.dart';
import 'app/pages/Bottom Nav/bottomnav_binding.dart';
import 'app/pages/Bottom Nav/bottomnav_view.dart';
import 'app/pages/Data Company Screen/data_company_binding.dart';
import 'app/pages/Data Company Screen/data_company_view.dart';
import 'app/pages/Login Screen/login_screen_binding.dart';
import 'app/pages/Login Screen/login_screen_view.dart';
import 'app/pages/Splash Screen/spalsh_screen_binding.dart';
import 'app/pages/Splash Screen/spalsh_screen_view.dart';

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
          initialRoute: '/splash',
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
              name: '/bottomnav',
              page: () => BottomNavView(),
              binding: BottomNavBinding(),
            ),
            GetPage(
              name: '/detaildata',
              page: () => DetailDataView(),
              binding: DetailDataBinding(),
            ),
            GetPage(
              name: '/detailhistory',
              page: () => DetailHistoryView(),
              binding: DetailHistoryBinding(),
            ),
            GetPage(
                name: '/EditDataHistory',
                page: () => EditDataHistoryView(),
                binding: EditDataHistoryBinding()
            ),
            GetPage(
                name: '/AccountClient',
                page: () => AccountClientView(),
                binding: AccountClientBinding()
            ),
            GetPage(
                name: '/AccountWorker',
                page: () => AccountWorkerView(),
                binding: AccountWorkerBinding()
            )
          ],
        );
      },
    );
  }
}
