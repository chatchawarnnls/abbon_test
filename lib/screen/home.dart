import 'dart:io';

import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:abbon_test_mobile/utilities/launch_url.dart';
import 'package:abbon_test_mobile/utilities/location.dart';
import 'package:abbon_test_mobile/widgets/map.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  File? _image;
  dynamic latitude;
  dynamic longitude;

  Future<void> openImageSelect(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentLocation();
    });
  }

  getCurrentLocation() async {
    try {
      var position = await CoreServiceLocation().getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;
      setState(() {});
    } catch (e) {
      rethrow;
    }
  }

  editProfile() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('SELECT_IMAGE').tr(),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              openImageSelect(ImageSource.camera);
              Navigator.of(context).pop();
            },
            child: Text('CAMERA').tr(),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              openImageSelect(ImageSource.gallery);
              Navigator.of(context).pop();
            },
            child: Text('GALLERY').tr(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: _image == null
                    ? Icon(Icons.account_circle, size: 150)
                    : ClipOval(
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            InkWell(
              onTap: () {
                editProfile();
              },
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: const Text(
                  "EDIT_PROFILE",
                  style: TextStyle(color: Colors.blue),
                ).tr(),
              ),
            ),
            Text(
              'CHATCHAWARN_SAELEE'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    if (latitude == null || longitude == null) {
                      getCurrentLocation();
                    } else {
                      CoreDeviceMap().openMap(
                        latitude: latitude,
                        longitude: longitude,
                      );
                    }
                  },
                  child: Icon(
                    Icons.pin_drop,
                    color: AppConfig.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    CoreServiceLaunchUrl().tel(phoneNumber: '0859756256');
                  },
                  child: Icon(
                    Icons.phone,
                    color: AppConfig.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    CoreServiceLaunchUrl().openEmail(email: 'chatchawarnnsl@gmail.com');
                  },
                  child: Icon(
                    Icons.email,
                    color: AppConfig.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    launchUrlString('https://line.me/ti/p/_XyI2JBerP');
                  },
                  child: SvgPicture.asset(
                    'assets/images/line.svg',
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
