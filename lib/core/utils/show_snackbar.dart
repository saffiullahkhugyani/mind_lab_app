import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';

enum FlushBarAction { error, success, info, warning }

void showFlushBar(BuildContext context, String content, FlushBarAction action) {
  if (action == FlushBarAction.info) {
    Flushbar(
      title: "Information",
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: Icon(Icons.info_outline, size: 28, color: Colors.blue[300]),
      leftBarIndicatorColor: Colors.blue,
      message: content,
      duration: const Duration(seconds: 5),
    ).show(context);
  } else if (action == FlushBarAction.success) {
    Flushbar(
      title: "Success",
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.info_outline,
          size: 28, color: AppPallete.successColor),
      leftBarIndicatorColor: AppPallete.successColor,
      message: content,
      duration: const Duration(seconds: 5),
    ).show(context);
  } else if (action == FlushBarAction.error) {
    Flushbar(
      title: "Error",
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.info_outline,
          size: 28, color: AppPallete.errorColor),
      leftBarIndicatorColor: AppPallete.errorColor,
      message: content,
      duration: const Duration(seconds: 5),
    ).show(context);
  } else {
    Flushbar(
      title: "Warning",
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.warning, size: 28, color: AppPallete.warning),
      leftBarIndicatorColor: AppPallete.warning,
      message: content,
      duration: const Duration(seconds: 5),
    ).show(context);
  }
}
