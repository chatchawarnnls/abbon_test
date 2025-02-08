import 'dart:convert';

import 'package:abbon_test_mobile/models/contact_results.dart';
import 'package:abbon_test_mobile/repositories/contact/contact_provider.dart';

class ContactRepository {
  final ContactProvider contactProvider = ContactProvider();

  Future<dynamic> getContact({required int page, required int pageSized}) async {
    try {
      dynamic res = await contactProvider.getContacts(page: page, pageSize: pageSized);
      if (res.statusCode == 200) {
        res = jsonDecode(res.body);
        return ContactResultModel.fromJson(res);
      } else {}
    } catch (e) {
      print(e.toString());
    }
  }
}
