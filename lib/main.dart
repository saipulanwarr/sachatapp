import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:sachatapp/app/utils/error_page.dart';
import 'package:sachatapp/app/utils/loading_page.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorPage();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            title: "Chat App",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          );
        }

        return LoadingPage();
      },
    );
  }
}
