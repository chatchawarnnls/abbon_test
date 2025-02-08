import 'package:abbon_test_mobile/utilities/config.dart/app_config.dart';
import 'package:http/http.dart' as http;

class ContactProvider {
  Future<dynamic> getContacts({required int page, required int pageSize}) async {
    final Uri url = Uri.parse('${AppConfig.apiUrl}/users?limit=$pageSize&skip=$page');
    dynamic res = await http.get(url);
    return res;
  }
}
