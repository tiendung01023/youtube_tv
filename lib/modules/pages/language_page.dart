// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:youtube_tv/modules/app_screen.dart';

class LanguagePage extends StatelessWidget {
  final MyAppBar appBar;
  final Widget drawer;
  final VoidCallback onChange;

  const LanguagePage({
    Key? key,
    required this.appBar,
    required this.drawer,
    required this.onChange,
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
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleEditLanguage(context),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
        ),
      ),
    );
  }

  void _handleEditLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      builder: (context) => _BottomSheet(onChange: onChange),
    );
  }
}

class _BottomSheet extends StatefulWidget {
  final VoidCallback onChange;
  const _BottomSheet({
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  State<_BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<_BottomSheet> {
  bool _isShowConfirm = false;
  String? _selectedLanguageCode;
  String? _selectedLanguageName;
  @override
  Widget build(BuildContext context) {
    if (!_isShowConfirm) {
      return _viewSelectLanguage(context);
    } else {
      return _viewConfirm(context);
    }
  }

  Widget _viewSelectLanguage(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => _showConfirmChangeLanguage('default', tr('language.system')),
              child: _itemSelectLanguage(tr('language.system')),
            ),
            Divider(color: Colors.grey[50], height: 1),
            InkWell(
              onTap: () => _showConfirmChangeLanguage('en', tr('language.en')),
              child: _itemSelectLanguage(tr('language.en')),
            ),
            Divider(color: Colors.grey[50], height: 1),
            InkWell(
              onTap: () => _showConfirmChangeLanguage('vi', tr('language.vi')),
              child: _itemSelectLanguage(tr('language.vi')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewConfirm(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Image.network(
                'https://www.gstatic.com/ytlr/img/language.png',
                alignment: Alignment.center,
              ),
            ),
            Text(
              tr('page_language_change_confirm_title', args: [_selectedLanguageName!]),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.5,
                fontSize: 24,
              ),
            ),
            _text(tr('page_language_change_confirm_subtitle')),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => _onChangeLanguage(),
              child: Container(
                width: MediaQuery.of(context).size.width / 3 * 2,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: Colors.grey[50],
                ),
                child: Text(
                  tr('page_language_change_confirm_button').toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w600,
                    height: 24 / 18,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _backToSelectLanguage(),
              child: Container(
                width: MediaQuery.of(context).size.width / 3 * 2,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  color: Colors.grey[700],
                ),
                child: Text(
                  tr('button_cancel').toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 24 / 18,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemSelectLanguage(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 16),
      child: _text(text, textAlign: TextAlign.center),
    );
  }

  Widget _text(String text, {TextAlign? textAlign}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
      child: Text(
        text,
        textAlign: textAlign,
        style: const TextStyle(
          color: Colors.white,
          height: 24 / 18,
          fontSize: 18,
        ),
      ),
    );
  }

  void _showConfirmChangeLanguage(String languageCode, String languageName) {
    setState(() {
      _selectedLanguageCode = languageCode;
      _selectedLanguageName = languageName;
      _isShowConfirm = true;
    });
  }

  void _backToSelectLanguage() {
    setState(() {
      _selectedLanguageCode = null;
      _selectedLanguageName = null;
      _isShowConfirm = false;
    });
  }

  Future<void> _onChangeLanguage() async {
    if (_selectedLanguageCode == 'default') {
      await context.resetLocale();
    } else {
      await context.setLocale(Locale(_selectedLanguageCode!));
    }
    Navigator.pop(context);
    widget.onChange();
  }
}
