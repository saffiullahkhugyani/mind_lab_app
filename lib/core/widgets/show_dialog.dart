import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String content, {
    String abortBtnText = 'No',
    String yesButtonText = "Yes",
    IconData icon = Icons.info,
  }) async {
    final ThemeData theme = Theme.of(context);
    final action = await showAdaptiveDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            icon: Icon(
              icon,
              size: 50,
            ),
            title: Text(title),
            content: Text(content),
            actions: [
              theme.platform == TargetPlatform.android
                  ? TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.abort),
                      child: Text(abortBtnText))
                  : CupertinoDialogAction(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.abort),
                      child: Text(abortBtnText)),
              theme.platform == TargetPlatform.android
                  ? ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.yes),
                      child: Text(yesButtonText))
                  : CupertinoDialogAction(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.yes),
                      child: Text(yesButtonText)),
            ],
          );
        });

    return (action != null) ? action : DialogAction.abort;
  }
}
