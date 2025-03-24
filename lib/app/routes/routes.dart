import 'package:admin/app/pages/Client/Create%20Account%20Client/create_account_client_view.dart';
import 'package:admin/app/pages/Worker/Create%20Account%20Worker/create_account_worker_binding.dart';
import 'package:admin/app/pages/Worker/Create%20Account%20Worker/create_account_worker_view.dart';
import 'package:get/get.dart';
import '../pages/Bottom Nav/bottomnav_binding.dart';
import '../pages/Bottom Nav/bottomnav_view.dart';
import '../pages/Client/Account Client/account_client_binding.dart';
import '../pages/Client/Account Client/account_client_view.dart';
import '../pages/Client/Create Account Client/create_account_client_binding.dart';
import '../pages/Client/Edit Account Client/edit_account_client_binding.dart';
import '../pages/Client/Edit Account Client/edit_account_client_view.dart';
import '../pages/Company/Data Company Screen/data_company_binding.dart';
import '../pages/Company/Data Company Screen/data_company_view.dart';
import '../pages/Company/Detail Data Screen/detail_data_binding.dart';
import '../pages/Company/Detail Data Screen/detail_data_view.dart';
import '../pages/Company/Detail History Screen/detail_binding.dart';
import '../pages/Company/Detail History Screen/detail_view.dart';
import '../pages/Company/Edit Data History Screen/edit_data_binding.dart';
import '../pages/Company/Edit Data History Screen/edit_data_view.dart';
import '../pages/Login Screen/login_screen_binding.dart';
import '../pages/Login Screen/login_screen_view.dart';
import '../pages/Splash Screen/spalsh_screen_binding.dart';
import '../pages/Splash Screen/spalsh_screen_view.dart';
import '../pages/Worker/Account Worker/account_worker_binding.dart';
import '../pages/Worker/Account Worker/account_worker_view.dart';
import '../pages/Worker/Edit Account Worker/edit_account_worker_binding.dart';
import '../pages/Worker/Edit Account Worker/edit_account_worker_view.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String bottomNav = '/bottomnav';
  static const String detailData = '/detaildata';
  static const String detailHistory = '/detailhistory';
  static const String accountClient = '/AccountClient';
  static const String accountWorker = '/AccountWorker';
  static const String editDataHistory = '/EditDataHistory';
  static const String editAccountClient = '/EditAccountClient';
  static const String editAccountWorker = '/EditAccountWorker';
  static const String createAccountWorker = '/CreateAccountWorker';
  static const String createAccountClient = '/CreateAccountClient';


  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: login,
      page: () => LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: bottomNav,
      page: () => BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: detailData,
      page: () => DetailDataView(),
      binding: DetailDataBinding(),
    ),
    GetPage(
      name: detailHistory,
      page: () => DetailHistoryView(),
      binding: DetailHistoryBinding(),
    ),
    GetPage(
      name: editDataHistory,
      page: () => EditDataHistoryView(),
      binding: EditDataHistoryBinding(),
    ),
    GetPage(
      name: accountClient,
      page: () => AccountClientView(),
      binding: AccountClientBinding(),
    ),
    GetPage(
      name: accountWorker,
      page: () => AccountWorkerView(),
      binding: AccountWorkerBinding(),
    ),
    GetPage(
      name: editAccountClient,
      page: () => EditAccountClientView(),
      binding: EditAccountClientBinding(),
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
      name: createAccountClient,
      page: () => CreateAccountClientView(),
      binding: CreateAccountClientBinding(),
    ),
  ];
}
