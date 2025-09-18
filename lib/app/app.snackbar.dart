// ui/setup/setup_snackbar_ui.dart
import 'package:flutter/material.dart';
import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_texts.dart';
import 'package:stacked_services/stacked_services.dart';

void setupSnackbarUi() {
  final service = locator<SnackbarService>();

  service.registerSnackbarConfig(SnackbarConfig(
    backgroundColor: kcBlue,
    textColor: kcWhite,
    mainButtonTextColor: kcWhite,
    borderRadius: 8,
    dismissDirection: DismissDirection.horizontal,
    snackPosition: SnackPosition.TOP, // atau BOTTOM
    margin: const EdgeInsets.all(20),
    maxWidth: 500,
    messageTextStyle: ktParagraphMedium.copyWith(color: kcWhite),
    titleTextStyle: ktParagraphBold.copyWith(color: kcWhite),
    snackStyle: SnackStyle.FLOATING, // atau GROUNDED
    isDismissible: true,
    duration: const Duration(seconds: 3),
  ));

  // Custom snackbar untuk success
  service.registerCustomSnackbarConfig(
    variant: 'success',
    config: SnackbarConfig(
      backgroundColor: Colors.green,
      textColor: kcWhite,
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      messageTextStyle: ktParagraphMedium.copyWith(color: kcWhite),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      duration: const Duration(seconds: 2),
    ),
  );

  // Custom snackbar untuk error
  service.registerCustomSnackbarConfig(
    variant: 'error',
    config: SnackbarConfig(
      backgroundColor: Colors.red,
      textColor: kcWhite,
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(20),
      messageTextStyle: ktParagraphMedium.copyWith(color: kcWhite),
      snackStyle: SnackStyle.FLOATING,
      isDismissible: true,
      duration: const Duration(seconds: 3),
    ),
  );
}
