import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/logic/common/api_client.dart';
import 'package:mobile/models/api_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

// Handles top-level authentication state for the application
class Auth extends ChangeNotifier {
  bool _isAuthenticated = false;

  ApiUser? user;
  String? token;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? error;

  Future<void> login(String email, String password) async {
    debugPrint("Attempting Auth Login.");
    final api = ApiClient();
    final prefs = await SharedPreferences.getInstance();

    _isAuthenticated = false;
    error = null;

    var response = await api.post("/api/token", {'email': email, 'password': password, 'device_name': "nm-mobile"});
    if (response.errorType == NetErrorType.none && response.body != null) {
      debugPrint("Authentication successful...");
      token = response.body as String;
      if (token != null) {
        prefs.setString('apitoken', token as String);
      } else {
        prefs.remove('apitoken');
      }

      _isAuthenticated = true;

      // Add callback to api to support checking for unauth issues
      debugPrint("Adding API Auth callback.");
      api.callback(_httpCallback);
      await _fetchUser();
    } else {
      debugPrint("There was a problem logging in.");
      inspect(response);
      if (response.body != null) error = jsonDecode(response.body as String);
    }

    debugPrint("Notifying listeners.");
    notifyListeners();
    debugPrint("Done");
  }

  void _httpCallback(HttpResponse response) async {
    debugPrint("In auth api callback.");
    if (!response.success && response.errorType == NetErrorType.denied) {
      debugPrint("Auth API callback sees api response is denied.  Logout.");
      // If unauthorized, we should logout
      await logout();
    }
  }

  // Check shared preferences for an api token. If exists, attempt to
  // fetch current user. If unable to, invalidate token. If so, set logged in
  // state
  init() async {
    debugPrint("Initializing Auth...");
    // Assign callback for any potential api auth failures

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('apitoken') != null) {
      user = await _fetchUser();
      debugPrint("We have a user that is logged in.");
      inspect(user);
    }
  }

  Future<ApiUser?> _fetchUser() async {
    debugPrint("Inside _fetchUser");
    // Get current user info
    HttpResponse response = await ApiClient().get('/api/info');
    if (response.success) {
      debugPrint(response.body);
      return ApiUser.fromJson(jsonDecode(response.body as String)["data"]);
    } else {
      //invalidate
      logout();
    }
    return null;
  }

  // Clear our user and notify any listeners
  logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    user = null;
    prefs.remove('apitoken');

    // Remove callback
    ApiClient().removeCallback(_httpCallback);
    notifyListeners();
  }
}
