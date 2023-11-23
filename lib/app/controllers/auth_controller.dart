import 'package:get/get.dart';
import 'package:sachatapp/app/routes/app_pages.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  void login() {
    Get.offAllNamed(Routes.HOME);
  }
}
