import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

extension _DateTimeExtension on DateTime {
  String format([String? pattern, String? locale]) {
    final dateFormat = DateFormat(pattern, locale);
    final result = dateFormat.format(this);
    return result;
  }
}

class Log {
  static final logData = <String>[];
  static final logFastData = <String>[];

  static String get time => DateTime.now().format('HH:mm:ss');

  static void _addLog(String text) {
    if (!kReleaseMode) {
      logData.add('[$time] $text');
    }
  }

  static void fast(String msg, {int? maxLength}) {
    final text = '[🌪 log_fast] $msg';
    final limitText = _cutLength(text, maxLength);
    if (kDebugMode) {
      print('[$time] $limitText');
    }
    _addLog(limitText);
    logFastData.add('[$time] $text');
  }

  static void d(String msg, {int? maxLength}) {
    final text = '[🌎 log_debug] $msg';
    final limitText = _cutLength(text, maxLength);
    if (kDebugMode) {
      print('[$time] $limitText');
    }
    _addLog(limitText);
  }

  static void w(String msg, {int? maxLength}) {
    final text = '[🤔 log_warning] $msg';
    final limitText = _cutLength(text, maxLength);
    if (kDebugMode) {
      print('[$time] $limitText');
    }
    _addLog(limitText);
  }

  static void e(String msg, {int? maxLength}) {
    final text = '[⛔ log_error] $msg';
    final limitText = _cutLength(text, maxLength);
    if (kDebugMode) {
      print('[$time] $limitText');
    }
    _addLog(limitText);
  }

  static void full(String msg, {int? maxLength}) {
    final text = '[🥶 log_full] $msg';
    final limitText = _cutLength(text, maxLength);
    if (kDebugMode) {
      log('[$time] $limitText');
    }
    _addLog(limitText);
  }

  static void json(dynamic msg, {int? maxLength, String? header}) {
    String text;
    try {
      String input;

      if (msg is Map<String, dynamic>) {
        input = jsonEncode(msg);
      } else if (msg is List) {
        input = jsonEncode(msg);
      } else {
        input = msg.toString();
      }

      /// Pretty Json
      input = prettyJson(input);

      /// Cut limit String in each between ''
      const limitLength = 1000;
      final pattern = RegExp(r'"([^"\\]|\\.)*"');
      final data = input.replaceAllMapped(pattern, (match) {
        final text2 = match.group(0);
        final limitText2 = _cutLength(text2, limitLength);
        return limitText2;
      });
      text = data;
    } catch (e) {
      text = msg.toString();
    }
    final limitText = header == null ? _cutLength(text, maxLength) : '$header\n${_cutLength(text, maxLength)}';

    final rs = '[🌝 log_json] $limitText';
    if (kDebugMode) {
      log('[$time] $rs');
    }
    _addLog(rs);
  }

  static String _cutLength(String? text, int? length) {
    if (text == null) return '';
    if (length == null || length == 0) return text;
    return text.length < length ? text : '${text.substring(0, length)}<...>"';
  }

  static String prettyJson(String input) {
    /// Pretty Json
    final object = jsonDecode(input);
    final prettyString = const JsonEncoder.withIndent('  ').convert(object);
    return prettyString;
  }
}
