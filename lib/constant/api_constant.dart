import 'package:flutter/foundation.dart';

class APIConstants {
  static const String _stagingBase = 'http://staging.scuts.in:5001/api/v1/';
  static const String _productionBase = 'https://api.Scuts.in/api/v1/';

  static String get baseUrl => kDebugMode ? _stagingBase : _productionBase;

  static String get image => kDebugMode
      ? 'http://staging.scuts.in:5001/'
      : 'https://api.Scuts.in/';

  /// Socket.IO server origin (same host/port as [baseUrl], without `/api/v1/`).
  static String get socketUrl {
    final u = Uri.parse(baseUrl);
    final port = u.hasPort ? ':${u.port}' : '';
    return '${u.scheme}://${u.host}$port';
  }
}
