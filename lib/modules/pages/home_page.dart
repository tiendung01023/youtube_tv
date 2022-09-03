import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_tv/modules/app_screen.dart';
import 'package:youtube_tv/utils/log.dart';

enum ScrollDirection { up, down, left, right }

class HomePage extends StatefulWidget {
  final MyAppBar appBar;
  final Widget drawer;
  final String tvUrl;
  final void Function(String? screenId, String? loungeToken, String? cookies) updateWebInfo;

  const HomePage({
    Key? key,
    required this.tvUrl,
    required this.appBar,
    required this.drawer,
    required this.updateWebInfo,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _spaceScroll = 100;
  WebViewController? _controller;

  Offset? _offset;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

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
        child: FutureBuilder(
            future: CookieManager().clearCookies(),
            builder: (context, _) {
              return GestureDetector(
                onHorizontalDragStart: _dragStart,
                onHorizontalDragUpdate: _dragUpdate,
                onHorizontalDragEnd: _dragEnd,
                onVerticalDragStart: _dragStart,
                onVerticalDragUpdate: _dragUpdate,
                onVerticalDragEnd: _dragEnd,
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
              );
            }),
      ),
    );
  }

  void _dragStart(DragStartDetails details) => _offset = details.globalPosition;
  void _dragUpdate(DragUpdateDetails details) {
    final offset = _offset;
    if (offset == null) return;

    final deltaX = details.globalPosition.dx - offset.dx;
    final deltaY = details.globalPosition.dy - offset.dy;
    double dx = offset.dx;
    double dy = offset.dy;

    if (deltaX < -_spaceScroll) {
      // Move LEFT
      Log.d('[HomePage][_dragUpdate] Move LEFT');
      _scrollWebview(39);
      dx = offset.dx - _spaceScroll;
    } else if (deltaX > _spaceScroll) {
      // Move RIGHT
      Log.d('[HomePage][_dragUpdate] Move RIGHT');
      _scrollWebview(37);
      dx = offset.dx + _spaceScroll;
    }

    if (deltaY < -_spaceScroll) {
      // Move UP
      Log.d('[HomePage][_dragUpdate] Move UP');
      _scrollWebview(40);
      dy = offset.dy - _spaceScroll;
    } else if (deltaY > _spaceScroll) {
      // Move DOWN
      Log.d('[HomePage][_dragUpdate] Move DOWN');
      _scrollWebview(38);
      dy = offset.dy + _spaceScroll;
    }

    _offset = Offset(dx, dy);
  }

  void _dragEnd(DragEndDetails details) => _offset = null;

  void _scrollWebview(int keyCode) {
    Log.d('[HomePage][_scrollWebview] run: $keyCode');

    _controller?.runJavascript('document.dispatchEvent(new KeyboardEvent("keydown",{keyCode:$keyCode}));');
    _controller?.runJavascript('document.dispatchEvent(new KeyboardEvent("keyup",{keyCode:$keyCode}));');
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
      final String? cookies = await _controller?.runJavascriptReturningResult('document.cookie');
      Log.d('[HomePage][_setScreenId] Cookies: $cookies');
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
        widget.updateWebInfo(screenId, loungeToken, cookies);
      }
    } catch (e) {
      Log.e('[HomePage][_setScreenId] $e');
    }
  }
}
