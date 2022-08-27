import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_tv/modules/components/contact_page.dart';
import 'package:youtube_tv/modules/components/home_page.dart';
import 'package:youtube_tv/modules/components/link_with_code_page.dart';
import 'package:youtube_tv/modules/components/link_with_wifi_page.dart';

typedef MyAppBar = PreferredSizeWidget Function({String? title, List<Widget>? actions});

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const _tvUrl = 'https://youtube.com/tv';
  String? _screenId;
  String? _loungeToken;

  int _currentIndexDrawer = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    CookieManager().clearCookies();
    final drawer = _drawer(context);

    Widget otherPage() {
      switch (_currentIndexDrawer) {
        case 1:
          return LinkWithCodePage(
            appBar: _appBar,
            drawer: drawer,
            screenId: _screenId,
            loungeToken: _loungeToken,
          );
        case 2:
          return LinkWithWifiPage(
            appBar: _appBar,
            drawer: drawer,
          );
        case 3:
          return ContactPage(
            appBar: _appBar,
            drawer: drawer,
          );
        default:
          return const SizedBox();
      }
    }

    return Stack(
      children: [
        HomePage(
          appBar: _appBar,
          tvUrl: _tvUrl,
          drawer: drawer,
          updateWebInfo: (screenId, loungeToken) {
            _screenId = screenId;
            _loungeToken = loungeToken;
          },
        ),
        otherPage(),
      ],
    );
  }

  PreferredSizeWidget _appBar({String? title, List<Widget>? actions}) {
    return AppBar(
      title: Text(title ?? "Youtube TV"),
      backgroundColor: Colors.red,
      actions: actions,
    );
  }

  Widget _drawer(BuildContext context) {
    Widget _item(int index, String title) {
      final isSelected = index == _currentIndexDrawer;
      return InkWell(
        onTap: () {
          setState(() {
            _currentIndexDrawer = index;
          });
          Navigator.pop(context);
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[50] : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        width: screenWidth / 2,
        color: Colors.grey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item(0, "Trang chủ"),
            _item(1, "Liên kết bằng mã TV"),
            _item(2, "Liên kết với Wi-Fi"),
            _item(3, "Liên hệ"),
          ],
        ),
      ),
    );
  }
}
