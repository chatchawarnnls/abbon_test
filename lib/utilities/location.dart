import 'dart:async';

import 'package:abbon_test_mobile/main.dart';
import 'package:abbon_test_mobile/widgets/button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class CoreServiceLocation {
  Position? position;
  StreamSubscription<Position>? positionStream;
  bool? _coreDeviceLocationIsPopupOpen = false;

  getCoreDeviceLocationIsPopupOpen() {
    return _coreDeviceLocationIsPopupOpen;
  }

  setCoreDeviceLocationIsPopupOpen(bool value) {
    _coreDeviceLocationIsPopupOpen = value;
  }

  getCurrentPosition({
    BuildContext? context,
    Function? onRetry,
  }) async {
    bool serviceEnabled;
    LocationPermission permission;
    bool permissionCheck = await checkPermissionAndShowAlertIfNeeded();

    if (!permissionCheck) {
      context = context ?? navigatorKey.currentContext!;
      if (getCoreDeviceLocationIsPopupOpen() == true) return;
      setCoreDeviceLocationIsPopupOpen(true);
      confirm(
        // ignore: use_build_context_synchronously
        context: context,
        buttonConfirmText: tr('GO_TO_SETTINGS'),
        callbackConfirm: () async {
          Navigator.popUntil(context!, (route) {
            return 0 == 2;
          });
          setCoreDeviceLocationIsPopupOpen(false);
          await Future.delayed(const Duration(milliseconds: 100));
          openAppSettings();
        },
        callbackCancel: () {
          if (onRetry != null) {
            onRetry();
          }
          Navigator.of(context!).pop();
          setCoreDeviceLocationIsPopupOpen(false);
        },
        msg: tr('DEVICE_LOCATION_PERMISSION_ALERT'),
      );
    } else {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.

          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        Permission.locationWhenInUse.request();
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      // cache 5s.
      if (position != null) {
        Duration difference = DateTime.now().difference(position!.timestamp);
        if (difference.inSeconds > 5) {
          position = await Geolocator.getCurrentPosition();

          return position!;
        } else {
          position = await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition();

          return position!;
        }
      }
      Position res = await Geolocator.getCurrentPosition();

      return Position(
        longitude: double.parse(res.longitude.toStringAsFixed(7)),
        latitude: double.parse(res.latitude.toStringAsFixed(7)),
        timestamp: res.timestamp,
        accuracy: res.accuracy,
        altitude: res.altitude,
        heading: res.heading,
        speed: res.speed,
        speedAccuracy: res.speedAccuracy,
        floor: res.floor,
        isMocked: res.isMocked,
        altitudeAccuracy: res.altitudeAccuracy,
        headingAccuracy: res.headingAccuracy,
      );
    }
  }

  Future<dynamic> confirm({
    required BuildContext context,
    required Function callbackConfirm,
    required Function callbackCancel,
    required String msg,
    String? title,
    String? buttonConfirmText,
    // String? buttonCancelText,
  }) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          ButtonWidget(
            text: buttonConfirmText ?? tr("WORKPLUS.SHARED.CONFIRM"),
            fontSize: 14,
            height: 35,
            width: 150,
            onTap: () {
              callbackConfirm();
            },
          ),
        ],
      ),
    );
  }

  checkPermissionAndShowAlertIfNeeded() async {
    await Future.delayed(const Duration(microseconds: 500));
    LocationPermission permission = await Geolocator.checkPermission();
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    // ignore: unnecessary_null_comparison, curly_braces_in_flow_control_structures
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: unnecessary_null_comparison
        if (serviceEnabled) {
          return false;
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Permission.locationWhenInUse.request();

      return false;
    }

    // Location permissions are granted, return true.
    return true;
  }
}
