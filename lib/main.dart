import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:sachatapp/app/controllers/auth_controller.dart';
import 'package:sachatapp/app/utils/error_screen.dart';
import 'package:sachatapp/app/utils/loading_screen.dart';
import 'package:sachatapp/app/utils/splash_screen.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return ErrorScreen();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            title: "Chat App",
            initialRoute: Routes.PROFILE,
            getPages: AppPages.routes,
          );
          // return FutureBuilder(
          //   future: Future.delayed(Duration(seconds: 3)),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Obx(
          //         () => GetMaterialApp(
          //           title: "Chat App",
          //           initialRoute: authC.isSkipIntro.isTrue
          //               ? authC.isAuth.isTrue
          //                   ? Routes.HOME
          //                   : Routes.LOGIN
          //               : Routes.INTRODUCTION,
          //           getPages: AppPages.routes,
          //         ),
          //       );
          //     }

          //     return SplashScreen();
          //   },
          // );
        }

        return LoadingScreen();
      },
    );
  }
}
