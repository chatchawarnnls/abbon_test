import 'dart:async';

import 'package:abbon_test_mobile/models/contact_results.dart';
import 'package:abbon_test_mobile/repositories/contact/contact_repository.dart';
import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:abbon_test_mobile/widgets/alert.dart';
import 'package:abbon_test_mobile/widgets/input_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactResultModel? itemContactListMaster;
  TextEditingController searchController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isHideForm = true;

  ScrollController? scrollController;
  ContactResultModel? itemContactList;
  Timer? debounce;

  int page = 0;
  int pageSize = 20;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getContact();
      scrollController = ScrollController()..addListener(loadMore);
    });
  }

  getContact() async {
    try {
      dynamic response = await ContactRepository().getContact(page: page, pageSized: pageSize);
      if (response is ContactResultModel) {
        if (page == 0) {
          itemContactListMaster = response;
        } else {
          itemContactListMaster?.users?.addAll(response.users ?? []);
        }
        itemContactList = itemContactListMaster;
        setState(() {});
      }
    } catch (e) {}
  }

  onSearch(String search) {
    if (debounce?.isActive ?? false) debounce!.cancel();
    if (search.isEmpty) {
      itemContactList = itemContactListMaster;
      setState(() {});
      return;
    }
    if (search.length < 3) return;
    debounce = Timer(const Duration(milliseconds: 500), () {
      itemContactList = itemContactListMaster?.copyWith(
        users: itemContactListMaster?.users
            ?.where((value) =>
                value.firstName!.toLowerCase().contains(search.toLowerCase()) ||
                value.lastName!.toLowerCase().contains(search.toLowerCase()))
            .toList(),
      );
      setState(() {});
    });
  }

  loadMore() {
    if (scrollController?.position.pixels == scrollController?.position.maxScrollExtent) {
      try {
        if ((itemContactList?.users?.length ?? 0) < 20) return;
        if ((itemContactList?.users?.length ?? 0) >= 100) return;
        page = page + 20;
        getContact();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future onRefresh() async {
    page = 0;
    searchController.clear();
    getContact();
  }

  addNewContact() {
    try {
      if (firstnameController.text.isEmpty || lastnameController.text.isEmpty || ageController.text.isEmpty) {
        CoreServiceAlert().show(context: context, message: 'PLEASE_FILL_ALL_FIELD'.tr());
        return;
      }
      UsersResultModel item = UsersResultModel(
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        age: int.parse(ageController.text),
      );
      itemContactList?.users?.insert(0, item);
      CoreServiceAlert().show(context: context, title: 'SUCCESS'.tr(), message: 'SUCCESS'.tr());
      firstnameController.clear();
      lastnameController.clear();
      ageController.clear();
      isHideForm = true;
      setState(() {});
    } catch (e) {
      CoreServiceAlert().show(context: context, title: 'ERROR'.tr(), message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'CONTACT'.tr(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: AppConfig.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            InputWidget(
              controller: searchController,
              context: context,
              hintText: 'SEARCH'.tr(),
              onChanged: onSearch,
              icon: InkWell(
                onTap: onRefresh,
                child: Icon(Icons.clear),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                isHideForm = !isHideForm;
                setState(() {});
              },
              child: Container(
                width: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: AppConfig.primaryColor),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (isHideForm == false) ...[
              const SizedBox(height: 16),
              InputWidget(
                controller: firstnameController,
                context: context,
                hintText: 'FRIST_NAME'.tr(),
              ),
              const SizedBox(height: 16),
              InputWidget(
                controller: lastnameController,
                context: context,
                hintText: 'LAST_NAME'.tr(),
              ),
              const SizedBox(height: 16),
              InputWidget(
                controller: ageController,
                context: context,
                hintText: 'AGE'.tr(),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: addNewContact,
                child: Text('ADD'.tr()),
              ),
            ],
            const SizedBox(height: 16),
            if (itemContactList == null)
              Center(
                child: CircularProgressIndicator(),
              )
            else ...[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: ListView.builder(
                    itemCount: itemContactList?.users?.length ?? 0,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      UsersResultModel item = itemContactList!.users![index];
                      return Card(
                        child: ListTile(
                          title: Text('${item.firstName ?? ""} ${item.lastName ?? ""}'),
                          subtitle: Text('${'AGE'.tr()} ${item.age ?? ""}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              CoreServiceAlert().confirm(
                                context: context,
                                callbackConfirm: () {
                                  itemContactList?.users?.removeAt(index);
                                  setState(() {});
                                },
                                callbackCancel: () {},
                                msg: 'CONFIRM_DELETE'.tr(),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
