import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youtube_tv/modules/app_screen.dart';

class LinkWithWifiPage extends StatelessWidget {
  final MyAppBar appBar;
  final Widget drawer;

  const LinkWithWifiPage({
    Key? key,
    required this.appBar,
    required this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: appBar(title: tr('page_link_with_wifi_title')),
      drawer: drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(tr('page_link_with_wifi_guide_1')),
              _text(tr('page_link_with_wifi_guide_2')),
              _text(tr('page_link_with_wifi_guide_3')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          height: 24 / 18,
          fontSize: 18,
        ),
      ),
    );
  }
}
