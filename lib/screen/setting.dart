import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:abbon_test_mobile/widgets/switch.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    String language = context.locale.toString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SETTING'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${'LANGUAGE'.tr()} (${'CURRENT_LANGUAGE'.tr()})'),
                SwitchWidget(
                  onChanged: (value) {
                    if (value) {
                      context.setLocale(const Locale('th'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                  },
                  value: language == 'th' ? true : false,
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                openAppSettings();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NOTIFICATION'.tr(),
                  ),
                  Icon(
                    Icons.notifications,
                    color: AppConfig.primaryColor,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
