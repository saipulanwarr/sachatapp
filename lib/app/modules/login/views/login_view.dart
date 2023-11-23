import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sachatapp/app/controllers/auth_controller.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Lottie.asset("assets/lottie/login.json"),
                ),
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () => authC.login(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset("assets/logo/google.png"),
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Sign in with google",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
