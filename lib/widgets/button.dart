import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final String? text;
  final Color? textColor;
  final Color? buttonColor;
  final Color? borderColor;
  final bool? isDisabled;
  final bool? widthAuto;
  final Function? onTap;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final double? borderRadius;

  const ButtonWidget({
    this.width,
    this.height,
    this.fontSize,
    this.text,
    this.textColor,
    this.buttonColor,
    this.borderColor,
    this.isDisabled,
    this.widthAuto,
    this.onTap,
    this.fontWeight,
    this.padding,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? buttonWidth;

    Widget buttonWidget() {
      return Opacity(
        opacity: isDisabled == true ? 0.5 : 1,
        child: Container(
          height: height ?? 46,
          width: buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 25.0),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
            ),
          ),
          child: TextButton(
            onPressed: onTap as void Function()?,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: buttonColor ?? AppConfig.primaryColor,
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 1),
              alignment: Alignment.center,
              child: Text(
                " ${text ?? ""} ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: fontWeight ?? FontWeight.bold,
                    fontSize: fontSize ?? 14),
              ),
            ),
          ),
        ),
      );
    }

    Widget widget;

    if (widthAuto == true) {
      widget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buttonWidget(),
        ],
      );
    } else if (width != null) {
      buttonWidth = width!;
      widget = buttonWidget();
    } else {
      buttonWidth = double.infinity;
      widget = buttonWidget();
    }
    return widget;
  }
}
