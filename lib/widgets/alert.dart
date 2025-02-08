import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:abbon_test_mobile/widgets/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CoreServiceAlert {
  Future<dynamic> show({required BuildContext context, String? title, String? message}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            title ?? "",
          )),
          content: Text(message ?? ""),
          actions: [
            ButtonWidget(
              text: 'OK'.tr(),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> confirm({
    required BuildContext context,
    required Function callbackConfirm,
    required Function callbackCancel,
    required String msg,
    String? title,
    String? buttonConfirmText,
    String? buttonCancelText,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title?.isNotEmpty == true) ...[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
              Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          ButtonWidget(
            text: buttonCancelText ?? tr("CLOSE"),
            fontSize: 14,
            height: 35,
            width: 100,
            borderColor: AppConfig.primaryColor,
            buttonColor: Colors.white,
            textColor: AppConfig.primaryColor,
            onTap: () {
              callbackCancel();
              Navigator.of(_).pop();
            },
          ),
          ButtonWidget(
            text: buttonConfirmText ?? tr("CONFIRM"),
            fontSize: 14,
            height: 35,
            width: 100,
            onTap: () {
              callbackConfirm();
              Navigator.of(_).pop();
            },
          ),
        ],
      ),
    );
  }
}
