import 'package:abbon_test_mobile/screen/contact.dart';
import 'package:abbon_test_mobile/screen/home.dart';
import 'package:abbon_test_mobile/screen/setting.dart';
import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            ContactScreen(),
            HomePageScreen(),
            SettingScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          color: AppConfig.primaryColor,
          child: TabBar(
            controller: _tabController,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            tabs: [
              Tab(
                icon: Icon(Icons.contact_phone),
                text: 'CONTACT'.tr(),
              ),
              Tab(
                icon: Icon(Icons.home),
                text: 'HOME'.tr(),
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: 'SETTING'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
