import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String content,
  ) async {
    final ThemeData theme = Theme.of(context);
    final action = await showAdaptiveDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text(title),
            content: Text(content),
            actions: [
              theme.platform == TargetPlatform.android
                  ? TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.abort),
                      child: const Text("Cancel"))
                  : CupertinoDialogAction(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.abort),
                      child: const Text("Cancel")),
              theme.platform == TargetPlatform.android
                  ? ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.yes),
                      child: const Text("Delete"))
                  : CupertinoDialogAction(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.yes),
                      child: const Text("Delete")),
            ],
          );
        });

    return (action != null) ? action : DialogAction.abort;
  }
}
