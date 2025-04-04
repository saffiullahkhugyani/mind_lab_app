import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, abort, cancel }

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
    final isIOS = theme.platform == TargetPlatform.iOS;

    final action = await showDialog<DialogAction>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: isIOS
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                )
              : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20), // Space for close button
                      Icon(icon, size: 50),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(content, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (isIOS)
                            CupertinoButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(DialogAction.abort),
                              child: Text(abortBtnText),
                            )
                          else
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(DialogAction.abort),
                              child: Text(abortBtnText),
                            ),
                          if (isIOS)
                            CupertinoButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(DialogAction.yes),
                              child: Text(yesButtonText),
                            )
                          else
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(DialogAction.yes),
                              child: Text(yesButtonText),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () =>
                        Navigator.of(context).pop(DialogAction.cancel),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return action ?? DialogAction.abort;
  }
}

// class Dialogs {
//   static Future<DialogAction> yesAbortDialog(
//     BuildContext context,
//     String title,
//     String content, {
//     String abortBtnText = 'No',
//     String yesButtonText = "Yes",
//     IconData icon = Icons.info,
//   }) async {
//     final ThemeData theme = Theme.of(context);

//     final action = await showAdaptiveDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog.adaptive(
//           contentPadding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 8),
//           content: Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(icon, size: 50),
//                     const SizedBox(height: 8),
//                     Text(title,
//                         style: Theme.of(context).textTheme.headlineSmall),
//                     const SizedBox(height: 8),
//                     Text(content, textAlign: TextAlign.center),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.grey),
//                   onPressed: () =>
//                       Navigator.of(context).pop(DialogAction.cancel),
//                 ),
//               ),
//             ],
//           ),
//           actions: [
//             if (theme.platform == TargetPlatform.android)
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(DialogAction.abort),
//                 child: Text(abortBtnText),
//               )
//             else
//               CupertinoDialogAction(
//                 onPressed: () => Navigator.of(context).pop(DialogAction.abort),
//                 child: Text(abortBtnText),
//               ),
//             if (theme.platform == TargetPlatform.android)
//               ElevatedButton(
//                 onPressed: () => Navigator.of(context).pop(DialogAction.yes),
//                 child: Text(yesButtonText),
//               )
//             else
//               CupertinoDialogAction(
//                 onPressed: () => Navigator.of(context).pop(DialogAction.yes),
//                 child: Text(yesButtonText),
//               ),
//           ],
//         );
//       },
//     );

//     return action ?? DialogAction.abort;
//   }
// }
