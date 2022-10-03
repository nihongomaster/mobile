import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;
import 'package:mobile/logic/common/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/logic/common/constants.dart' as constants;

enum NetErrorType {
  none,
  disconnected,
  timedOut,
  denied,
}

enum MethodType { get, post, put, patch, delete, head }

typedef HttpRequest = Future<http.Response> Function();

// A singleton that represents our api client
class ApiClient {
  static final ApiClient _instance = ApiClient._create();

  List<Function> callbacks = [];

  // Private Constructor
  ApiClient._create();

  factory ApiClient() {
    return _instance;
  }

  // Get api token from shared prefs, otherwise null
  Future<String?> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('apitoken');
  }

  // Create default set of headers for api requests
  Future<Map<String, String>> _headers(Map<String, String>? incoming) async {
    String? token = await _token();
    return {if (token != null) "Authorization": "Bearer $token", "Accept": 'application/json'}..addAll(incoming ?? {});
  }

  // Add a callback to listen for any response.  Useful if tracking unauthorized or any error
  void callback(Function callback) {
    callbacks.add(callback);
  }

  void removeCallback(Function callback) {
    callbacks.removeWhere((cb) => cb == callback);
  }

  // Perform a GET request against api endpoint
  Future<HttpResponse> get(String url, {Map<String, String>? headers}) async {
    return await _request(() async {
      return await http.get(Uri.parse("${constants.apiUrl}$url"), headers: await _headers(headers));
    });
  }

  Future<HttpResponse> post(String url, Map<String, String>? body, {Map<String, String>? headers}) async {
    return await _request(() async {
      return await http.post(Uri.parse("${constants.apiUrl}$url"), body: body, headers: await _headers(headers));
    });
  }

  Future<HttpResponse> _request(HttpRequest request) async {
    http.Response response;
    try {
      response = await request();
    } on Exception catch (e) {
      dev.log('Network call failed: ${e.toString()}');
      response = http.Response('ERROR: Could not get a response', 404);
    }

    dev.inspect(response.body);

    // Handle callbacks
    HttpResponse htr = HttpResponse(response);
    for (Function cb in callbacks) {
      cb(htr);
    }

    return htr;
  }
}

class HttpResponse {
  final http.Response? raw;

  NetErrorType? errorType;

  bool get success => errorType == NetErrorType.none;

  String? get body => raw?.body;

  Map<String, String>? get headers => raw?.headers;

  int get statusCode => raw?.statusCode ?? -1;

  HttpResponse(this.raw) {
    //No response at all, there must have been a connection error
    if (raw == null) {
      errorType = NetErrorType.disconnected;
    } else if (raw!.statusCode >= 200 && raw!.statusCode <= 299) {
      errorType = NetErrorType.none;
    } else if (raw!.statusCode >= 500 && raw!.statusCode < 600) {
      errorType = NetErrorType.timedOut;
    } else if (raw!.statusCode >= 400 && raw!.statusCode < 500) {
      errorType = NetErrorType.denied;
    }
  }
}

class ServiceResult<R> {
  final HttpResponse response;

  R? content;

  bool get parseError => content == null;
  bool get success => response.success && !parseError;

  ServiceResult(this.response, R Function(Map<String, dynamic>) parser) {
    if (StringUtils.isNotEmpty(response.body) && response.success) {
      try {
        content = parser.call(jsonDecode(response.body!));
      } on FormatException catch (e) {
        dev.log('ParseError: ${e.message}');
      }
    }
  }
}
