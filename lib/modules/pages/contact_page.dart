import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_tv/modules/app_screen.dart';

class ContactPage extends StatelessWidget {
  final MyAppBar appBar;
  final Widget drawer;

  const ContactPage({
    Key? key,
    required this.appBar,
    required this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: appBar(title: tr('page_contact_title')),
      drawer: drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _version(),
              _action(
                Icons.call,
                "+8433 3093 831",
                () => _launchUrl('tel:+84333093831'),
              ),
              _action(
                Icons.mail,
                "tiendung01023@gmail.com",
                () => _launchUrl('mailto:tiendung01023@gmail.com'),
              ),
              _action(
                Icons.facebook,
                "Facebook Messenger",
                () => _launchUrl('https://m.me/tidu01059a', mode: LaunchMode.externalApplication),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _version() {
    Future<String> getVersion() async {
      final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = packageInfo.version;
      return appVersion;
    }

    return FutureBuilder<String>(
      future: getVersion(),
      builder: (context, snapshot) {
        final version = snapshot.data;

        if (version == null) return const SizedBox();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Text(
            tr('version_title', args: [version]),
            style: const TextStyle(
              color: Colors.white,
              height: 24 / 18,
              fontSize: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _action(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  height: 24 / 18,
                  fontSize: 18,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url, {LaunchMode mode = LaunchMode.platformDefault}) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: mode,
    )) {
      throw '[_launchUrl] Could not launch $url';
    }
  }
}
