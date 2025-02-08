import 'package:url_launcher/url_launcher.dart';

class CoreServiceLaunchUrl {
  Future<void> tel({
    required String phoneNumber,
  }) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    await launchUrl(launchUri);
  }

  Future<void> openEmail({
    required String email,
    String? subject,
  }) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
    }

    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{'subject': subject ?? ""}),
    );

    await launchUrl(launchUri);
  }
}
