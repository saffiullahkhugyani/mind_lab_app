import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/theme/app_pallete.dart';

enum BottomSheetAction { yes, abort }

class BottomSheets {
  static Future<BottomSheetAction> yesAbortBottonSheet(
      Widget child, BuildContext context) async {
    final action = await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => buildSheet(context, child),
    );

    return (action != null) ? action : BottomSheetAction.abort;
  }

  static Widget buildSheet(BuildContext context, Widget child) =>
      DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: controller,
            children: [
              IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  Navigator.of(context).pop(BottomSheetAction.abort);
                },
                icon: const Icon(Icons.cancel),
                color: AppPallete.errorColor,
              ),
              child,
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(BottomSheetAction.yes);
                  },
                  child: const Text("Accept"))
            ],
          ),
        ),
      );
}
