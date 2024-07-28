import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

enum AppUpdateAction { yes, abort }

class AppUpgraderDialog extends UpgradeAlert {
  AppUpgraderDialog(
      {super.key, super.upgrader, super.child, super.shouldPopScope});

  /// Override the [createState] method to provide a custom class
  /// with overridden methods.
  @override
  UpgradeAlertState createState() => MyUpgradeAlertState();
}

class MyUpgradeAlertState extends UpgradeAlertState {
  @override
  void showTheDialog({
    Key? key,
    required BuildContext context,
    required String? title,
    required String message,
    required String? releaseNotes,
    required bool barrierDismissible,
    required UpgraderMessages messages,
  }) async {
    // Save the date/time as the last time alerted.
    widget.upgrader.saveLastAlerted();

    final ThemeData theme = Theme.of(context);
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog.adaptive(
            icon: const Icon(
              Icons.update,
              size: 50,
            ),
            title: Text(title!),
            content: const Text(
                "Please update your application to the latest version to enjoy the application features."),
            actions: [
              theme.platform == TargetPlatform.android
                  ? TextButton(
                      onPressed: () =>
                          performAction(context, AppUpdateAction.abort),
                      child: const Text("Cancel"))
                  : CupertinoDialogAction(
                      onPressed: () =>
                          performAction(context, AppUpdateAction.abort),
                      child: const Text("Cancel")),
              theme.platform == TargetPlatform.android
                  ? ElevatedButton(
                      onPressed: () =>
                          performAction(context, AppUpdateAction.yes),
                      child: const Text("Update"))
                  : CupertinoDialogAction(
                      onPressed: () =>
                          performAction(context, AppUpdateAction.yes),
                      child: const Text("Update")),
            ],
          ),
        );
      },
    );
  }

  void performAction(BuildContext context, AppUpdateAction actionState) {
    if (actionState == AppUpdateAction.abort) {
      onUserLater(context, true);
    }

    if (actionState == AppUpdateAction.yes) {
      onUserUpdated(context, !widget.upgrader.blocked());
    }
  }
}

class AppUpgrader extends Upgrader {
  AppUpgrader(
      {super.debugLogging,
      super.durationUntilAlertAgain,
      super.debugDisplayAlways});

  @override
  bool isUpdateAvailable() {
    final storeVersion = currentAppStoreVersion;
    final installedVersion = currentInstalledVersion;
    print('storeVersion=$storeVersion');
    print('installedVersion=$installedVersion');
    return super.isUpdateAvailable();
  }
}
