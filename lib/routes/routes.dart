import 'package:admin/app/pages/Client/Create%20Account%20Client/create_account_client_view.dart';
import 'package:admin/app/pages/Company/Create%20Qr%20Company/create_qr_company_binding.dart';
import 'package:admin/app/pages/Company/Create%20Qr%20Company/create_qr_company_view.dart';
import 'package:admin/app/pages/Company/tools/Create%20Qr%20Tools/create_qr_tools_binding.dart';
import 'package:admin/app/pages/Company/tools/Create%20Qr%20Tools/create_qr_tools_view.dart';
import 'package:admin/app/pages/Company/tools/Edit%20Tools/update_qr_tools_binding.dart';
import 'package:admin/app/pages/Company/tools/Edit%20Tools/update_qr_tools_view.dart';
import 'package:admin/app/pages/Company/tools/History/history_tools_binding.dart';
import 'package:admin/app/pages/Worker/Create%20Account%20Worker/create_account_worker_binding.dart';
import 'package:admin/app/pages/Worker/Create%20Account%20Worker/create_account_worker_view.dart';
import 'package:get/get.dart';
import '../app/pages/Bottom Nav/bottomnav_binding.dart';
import '../app/pages/Bottom Nav/bottomnav_view.dart';
import '../app/pages/Client/Account Client/account_client_binding.dart';
import '../app/pages/Client/Account Client/account_client_view.dart';
import '../app/pages/Client/Create Account Client/create_account_client_binding.dart';
import '../app/pages/Client/Edit Account Client/edit_account_client_binding.dart';
import '../app/pages/Client/Edit Account Client/edit_account_client_view.dart';
import '../app/pages/Company/Detail Data Screen/detail_data_binding.dart';
import '../app/pages/Company/Detail Data Screen/detail_data_view.dart';
import '../app/pages/Company/Detail History Screen/detail_binding.dart';
import '../app/pages/Company/Detail History Screen/detail_view.dart';
import '../app/pages/Company/tools/Detail_Tools/Detail_Tool_binding.dart';
import '../app/pages/Company/tools/Detail_Tools/Detail_Tool_view.dart';
import '../app/pages/Company/Edit Data History Screen/edit_data_binding.dart';
import '../app/pages/Company/Edit Data History Screen/edit_data_view.dart';
import '../app/pages/Company/tools/History/history_tools_view.dart';
import '../app/pages/Login screen/login_view.dart';
import '../app/pages/Splash screen/splash_binding.dart';
import '../app/pages/Splash screen/splash_view.dart';
import '../app/pages/Worker/Account Worker/account_worker_binding.dart';
import '../app/pages/Worker/Account Worker/account_worker_view.dart';
import '../app/pages/Worker/Edit Account Worker/edit_account_worker_binding.dart';
import '../app/pages/Worker/Edit Account Worker/edit_account_worker_view.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String botomnav = '/bottomnav';

  static const String accountClient = '/AccountClient';
  static const String editAccountClient = '/EditAccountClient';
  static const String createAccountClient = '/CreateAccountClient';


  static const String createQrTools = '/CreateQrTools';
  static const String createQrCompany = '/CreateQrCompany';
  static const String editDataHistory = '/EditDataHistory';
  static const String detailHistory = '/detailhistory';
  static const String detailData = '/detaildata';
  static const String createAccountCompany = '/CreateAccountCompany';
  static const String historytool = '/historytool';
  static const String detailtool = '/detailtool';
  static const String updatetool = '/updatetool';


  static const String editAccountWorker = '/EditAccountWorker';
  static const String createAccountWorker = '/CreateAccountWorker';
  static const String accountWorker = '/AccountWorker';





  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: login,
      page: () => LoginView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: botomnav,
      page: () => BottomNavView(),
      binding: BottomNavBinding(),
    ),


    GetPage(
      name: accountClient,
      page: () => AccountClientView(),
      binding: AccountClientBinding(),
    ),
    GetPage(
      name: editAccountClient,
      page: () => EditAccountClientView(),
      binding: EditAccountClientBinding(),
    ),
    GetPage(
      name: createAccountClient,
      page: () => CreateAccountClientView(),
      binding: CreateAccountClientBinding(),
    ),
    GetPage(
      name: createAccountCompany,
      page: () => CreateQrCompanyView(),
      binding: CreateQrCompanyBinding(),
    ),

    GetPage(
      name: Routes.detailData,
      page: () => DetailDataView(),
      binding: DetailDataBinding(),
    ),
    GetPage(
      name: Routes.detailHistory,
      page: () => DetailHistoryView(),
      binding: DetailHistoryBinding(),
    ),
    GetPage(
      name: Routes.editDataHistory,
      page: () => EditDataHistoryView(),
      binding: EditDataHistoryBinding(),
    ),
    GetPage(
      name: Routes.createQrCompany,
      page: () => CreateQrCompanyView(),
      binding: CreateQrCompanyBinding(),
    ),
    GetPage(
      name: Routes.createQrTools,
      page: () => CreateQrToolView(),
      binding: CreateQrToolBinding(),
    ),
    GetPage(
      name: Routes.historytool,
      page: () => HistoryToolView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.detailtool,
      page: () => DetailToolView(),
      binding: DetailToolBinding(),
    ),
    GetPage(
      name: Routes.updatetool,
      page: () => EditToolView(),
      binding: EditToolBinding(),
    ),


    GetPage(
      name: editAccountWorker,
      page: () => EditAccountWorkerView(),
      binding: EditAccountWorkerBinding(),
    ),
    GetPage(
      name: createAccountWorker,
      page: () => CreateAccountWorkerView(),
      binding: CreateAccountWorkerBinding(),
    ),
    GetPage(
      name: accountWorker,
      page: () => AccountWorkerView(),
      binding: AccountWorkerBinding(),
    ),

  ];
}
