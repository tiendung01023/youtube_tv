import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:youtube_tv/modules/app_screen.dart';
import 'package:youtube_tv/utils/log.dart';
import 'package:youtube_tv/utils/logging_interceptors.dart';

class LinkWithCodePage extends StatefulWidget {
  final MyAppBar appBar;
  final Widget drawer;

  final String? screenId;
  final String? loungeToken;

  const LinkWithCodePage({
    Key? key,
    required this.appBar,
    required this.drawer,
    required this.screenId,
    required this.loungeToken,
  }) : super(key: key);

  @override
  State<LinkWithCodePage> createState() => _LinkWithCodePageState();
}

class _LinkWithCodePageState extends State<LinkWithCodePage> {
  String? _code;

  @override
  void initState() {
    super.initState();
    _loadNewCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: widget.appBar(
        title: 'Liên kết bằng mã TV',
        actions: [
          IconButton(
            onPressed: () => _loadNewCode(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      drawer: widget.drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: widget.screenId == null
              ? _text("Có lỗi trong khi lấy mã")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _text("1. Trên điện thoại, hãy mở ứng dụng YouTube."),
                    _text("2. Nhấn vào biểu tượng Chromecast."),
                    _text("3. Nhấn vào \"Liên kết bằng mã TV\" rồi nhập mã vào phần bên dưới."),
                    const SizedBox(height: 8),
                    _codeWidget(),
                    Image.network(
                      'http://www.gstatic.com/ytlr/img/link_with_tv_code_static.png',
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _codeWidget() {
    final code = _code;
    if (code == null) return const SizedBox();
    final codeList = <String>[];
    for (var i = 0; i < code.length; i = i + 3) {
      codeList.add(code.substring(i, i + 3));
    }
    return SizedBox(
      width: double.infinity,
      child: Text(
        codeList.join(' '),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.blue[700],
          fontSize: 40,
          fontWeight: FontWeight.w800,
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

  void _loadNewCode() {
    Log.d('[App][_loadNewCode] run');
    _getTVLinkCodeApi().then((value) {
      setState(() {
        _code = value;
      });
    });
  }

  Future<String?> _getTVLinkCodeApi() async {
    Log.d('[App][_getTVLinkCodeApi] run');
    try {
      if (widget.screenId == null) {
        Log.e('[App][_getTVLinkCodeApi] screenId is null');
        return null;
      }
      final dio = Dio();
      dio.interceptors.addAll([LoggingInterceptors()]);
      final res = await dio.post(
        'https://www.youtube.com/api/lounge/pairing/get_pairing_code?ctx=pair',
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
        data: {
          'access_type': 'permanent',
          'screen_name': 'YoutubeTV',
          'screen_id': widget.screenId,
          'lounge_token': widget.loungeToken,
        },
      );
      final data = res.data;
      if (res.statusCode == 200 && data is String && data.isNotEmpty) {
        return data;
      }
    } catch (e) {
      Log.e('[App][_getTVLinkCodeApi] $e');
    }
    return null;
  }
}
