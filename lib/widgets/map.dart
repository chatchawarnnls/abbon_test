import 'package:abbon_test_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';

class CoreDeviceMap {
  openMap({
    required dynamic latitude,
    required dynamic longitude,
    String? title,
  }) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      final coords = Coords(latitude, longitude);
      showModalBottomSheet(
        context: navigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title ?? "",
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          width: 24,
                          height: 24,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
