import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasir/app/modules/auth/login/views/loginpage.dart';
import 'package:kasir/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kasir Mantap',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   fontFamily: 'Inter',
      // ),
      getPages: AppPages.routes,
      home: LoginPage(),
    );
  }
}
