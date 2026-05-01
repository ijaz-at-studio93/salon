class APIConstants {
  // static const String baseUrl = 'https://api.Scuts.in/api/v1/';
  static const String baseUrl = 'http://staging.scuts.in:5001/api/v1/';
  // static const String image = 'https://api.Scuts.in/';
  static const String image = 'http://staging.scuts.in:5001/';

  /// Socket.IO server origin (same host/port as [baseUrl], without `/api/v1/`).
  static String get socketUrl {
    final u = Uri.parse(baseUrl);
    final port = u.hasPort ? ':${u.port}' : '';
    return '${u.scheme}://${u.host}$port';
  }

  // static const String baseUrl = 'http://192.168.31.62:3001/api/v1/';
  // static const String baseUrl = 'https://6965-2409-40f2-159-d904-d9f0-5740-4416-f687.ngrok-free.app/api/v1/';
}
