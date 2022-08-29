import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youtube_tv/modules/app_screen.dart';

class LanguagePage extends StatelessWidget {
  final MyAppBar appBar;
  final Widget drawer;

  const LanguagePage({
    Key? key,
    required this.appBar,
    required this.drawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: appBar(title: tr('page_language_title')),
      drawer: drawer,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 120,
                child: Image.network(
                  'https://www.gstatic.com/ytlr/img/language.png',
                  alignment: Alignment.center,
                ),
              ),
              _text(tr('page_language_guide')),
              _buttonChangeLanguage(context),
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

  Widget _buttonChangeLanguage(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: InkWell(
        onTap: () => _handleEditLanguage(context),
        child: Row(
          children: [
            Expanded(
              child: Text(
                tr('language', gender: context.locale.languageCode),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.grey[900],
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    context.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                  child: _text(tr('language.en')),
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[50]),
                InkWell(
                  onTap: () {
                    context.setLocale(const Locale('vi'));
                    Navigator.pop(context);
                  },
                  child: _text(tr('language.vi')),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
