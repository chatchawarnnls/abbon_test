import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final Function(bool) onChanged;
  final Color? activeColor;
  final bool value;
  const SwitchWidget({super.key, required this.onChanged, required this.value, this.activeColor});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      activeColor: activeColor ?? AppConfig.primaryColor,
      onChanged: (bool value) {
        onChanged(value);
      },
    );
  }
}
