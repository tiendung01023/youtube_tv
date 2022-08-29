import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_tv/modules/app_screen.dart';
import 'package:youtube_tv/utils/log.dart';

class HomePage extends StatefulWidget {
  final MyAppBar appBar;
  final Widget drawer;
  final String tvUrl;
  final void Function(String? screenId, String? loungeToken) updateWebInfo;

  const HomePage({
    Key? key,
    required this.appBar,
    required this.drawer,
    required this.tvUrl,
    required this.updateWebInfo,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: widget.appBar(
        actions: [
          IconButton(
            onPressed: () => _reload(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      drawer: widget.drawer,
      body: SafeArea(
        child: WebView(
          backgroundColor: Colors.white,
          initialUrl: widget.tvUrl,
          gestureNavigationEnabled: true,
          userAgent: 'AppleCoreMedia/1.0.0.12B466 (Apple TV; U; CPU OS 8_1_3 like Mac OS X; en_us)',
          onPageFinished: (_) => _setScreenId(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) => _controller = controller,
          navigationDelegate: (navigation) {
            Log.d('[HomePage][navigationDelegate] ${navigation.url}');
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }

  Future<void> _reload() async {
    Log.d('[HomePage][_reload] run');
    await _controller?.loadUrl(widget.tvUrl);
  }

  Future<void> _setScreenId() async {
    Log.d('[HomePage][_setScreenId] run');
    try {
      final res =
          await _controller?.runJavascriptReturningResult("window.localStorage['yt.leanback.default::yt_mdx_screen']");
      if (res != null && res != '') {
        Log.d('[HomePage][_setScreenId] data: $res');
        dynamic resDecode = jsonDecode(res);
        Map<String, dynamic> resMap;
        if (resDecode is String) {
          resMap = jsonDecode(resDecode) as Map<String, dynamic>;
        } else if (resDecode is Map<String, dynamic>) {
          resMap = resDecode;
        } else {
          resMap = {};
        }
        Log.json(resMap, header: '[HomePage][_setScreenId]');

        final screenId = resMap['data']?['screenId'] as String?;
        final loungeToken = resMap['data']?['loungeToken'] as String?;
        widget.updateWebInfo(screenId, loungeToken);
      }
    } catch (e) {
      Log.e('[HomePage][_setScreenId] $e');
    }
  }
}
