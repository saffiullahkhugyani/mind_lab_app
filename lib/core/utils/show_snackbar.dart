import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';

enum FlashBarAction { error, success, info, warning }

void showFlashBar(BuildContext context, String content, FlashBarAction action) {
  if (action == FlashBarAction.info) {
    context.showFlash(
      barrierColor: Colors.black54,
      duration: const Duration(seconds: 3),
      builder: (context, controller) => FlashBar(
        title: const Text('Information'),
        content: Text(content),
        icon: const Icon(
          Icons.info_outline,
          color: AppPallete.infoColor,
          size: 28,
        ),
        controller: controller,
        clipBehavior: Clip.hardEdge,
        indicatorColor: AppPallete.infoColor,
        behavior: FlashBehavior.floating,
        margin: const EdgeInsets.all(8),
      ),
    );
  } else if (action == FlashBarAction.success) {
    context.showFlash(
      barrierColor: Colors.black54,
      duration: const Duration(seconds: 3),
      builder: (context, controller) => FlashBar(
        title: const Text('Success'),
        content: Text(content),
        controller: controller,
        clipBehavior: Clip.hardEdge,
        indicatorColor: AppPallete.successColor,
        behavior: FlashBehavior.floating,
        icon: const Icon(
          Icons.check,
          color: AppPallete.successColor,
          size: 28,
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  } else if (action == FlashBarAction.error) {
    context.showFlash(
      barrierColor: Colors.black54,
      duration: const Duration(seconds: 3),
      builder: (context, controller) => FlashBar(
        title: const Text('Error'),
        content: Text(content),
        controller: controller,
        clipBehavior: Clip.hardEdge,
        indicatorColor: AppPallete.errorColor,
        behavior: FlashBehavior.floating,
        icon: const Icon(
          Icons.error,
          color: AppPallete.errorColor,
          size: 28,
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  } else if (action == FlashBarAction.warning) {
    context.showFlash(
      barrierColor: Colors.black54,
      reverseTransitionDuration: const Duration(seconds: 1),
      duration: const Duration(seconds: 5),
      builder: (context, controller) => FlashBar(
        title: const Text('Warning'),
        content: Text(content),
        controller: controller,
        clipBehavior: Clip.hardEdge,
        indicatorColor: AppPallete.warning,
        behavior: FlashBehavior.floating,
        icon: const Icon(
          Icons.warning,
          color: AppPallete.warning,
          size: 28,
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }
}
