import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_bindings.dart';
import 'screens/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

///
///
///
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bamrec Events',
      debugShowCheckedModeBanner: false,
      initialBinding: createBindings(context),
      home: const SplashScreen(),
    );
  }
}
