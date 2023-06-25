import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies_task/utils/app_images_path.dart';

import 'movies_list_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoHome();
    super.initState();
  }

  Future<void> gotoHome() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const MoviesListWidget());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          AppImagesPath.splashGif,
        ),
      ),
    );
  }
}
