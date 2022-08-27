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
      appBar: appBar(title: 'Liên kết với Wi-Fi'),
      drawer: drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text("1. Hãy kết nối điện thoại với cùng mạng Wi-Fi mà thiết bị này đang sử dụng."),
              _text("2. Mở ứng dụng YouTube trên điện thoại."),
              _text("3. Nhấn vào biểu tượng truyền rồi chọn thiết bị này."),
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
