import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

///
///
///
///
///

//

void showSuccessMessage(
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(Get.context!);
  s.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyle.boldWhite10,
      ),
      backgroundColor: AppColors.green,
    ),
  );
}

///
///
///
void showErrorMessage(
  String message, {
  ScaffoldMessengerState? messengerState,
}) {
  final s = messengerState ?? ScaffoldMessenger.of(Get.context!);
  s.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyle.boldWhite10,
      ),
      backgroundColor: AppColors.red,
    ),
  );
}
