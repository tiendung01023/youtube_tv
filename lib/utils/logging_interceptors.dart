import 'package:dio/dio.dart';

import 'log.dart';

class LoggingInterceptors extends Interceptor {
  static const _maxLengthLog = 0;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final url = _getUrl(options);
    final method = options.method;
    // final token = options.headers['Authorization'].toString();
    final contentType = options.contentType;
    var dataType = 'Unknown Type';
    var data = options.data;
    if (data == null) {
      dataType = '--EMPTY--';
    } else if (data is Map) {
      dataType = 'JSON';
    } else if (data is FormData) {
      dataType = 'FormData';
      data = data.fields;
    }

    var token = options.headers['Authorization'] as String?;
    if (token != null) {
      final length = token.length;
      token = token.substring(length - 10, length);
      token = '...$token';
    }

    final logs = <String>[];
    logs.add(_addColor("[onRequest]", LogColor.green));
    logs.add('[$method] $url');
    logs.add('[Token] $token');
    logs.add('[contentType] $contentType');
    logs.add('[data] $dataType');
    Log.json(
      data,
      header: logs.join('\n'),
      maxLength: _maxLengthLog,
    );
    return super.onRequest(options, handler);
  }

  String _getUrl(RequestOptions options) {
    var url = '${options.baseUrl}${options.path}';
    if (options.queryParameters.isNotEmpty) {
      url = '$url?${Transformer.urlEncodeMap(options.queryParameters)}';
    }
    return url;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final options = response.requestOptions;
    final url = _getUrl(options);
    final method = options.method;
    final data = response.data;

    final logs = <String>[];
    logs.add(_addColor("[onResponse]", LogColor.purple));
    logs.add('[$method] $url');
    logs.add('[${response.statusCode}] ${response.statusMessage}');
    Log.json(
      data,
      header: logs.join('\n'),
      maxLength: _maxLengthLog,
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final response = err.response;

    final options = err.requestOptions;
    final url = _getUrl(options);
    final method = options.method;
    final data = response?.data ?? err.error.toString();

    final logs = <String>[];
    logs.add(_addColor("[onError]", LogColor.red));
    logs.add(_addColor('[$method] $url', LogColor.red));
    logs.add('[errorType] ${err.type}');
    if (response != null) {
      logs.add('[${response.statusCode}] ${response.statusMessage}');
    }

    Log.json(
      data,
      header: logs.join('\n'),
      maxLength: _maxLengthLog,
    );
    return super.onError(err, handler);
  }

  String _addColor(String text, LogColor color) {
    switch (color) {
      case LogColor.purple:
        return '\x1B[35m$text\x1B[0m';
      case LogColor.green:
        return '\x1B[32m$text\x1B[0m';
      case LogColor.red:
        return '\x1B[31m$text\x1B[0m';
      default:
        return text;
    }
  }
}

enum LogColor { purple, green, red }
