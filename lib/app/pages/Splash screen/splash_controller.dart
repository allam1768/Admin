import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  var scale = 0.5.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
    _checkLoginStatus();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    scale.value = 1;
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (isLoggedIn) {
      Get.offNamed('/bottomnav');
    } else {
      Get.offNamed('/login');
    }
  }
}
