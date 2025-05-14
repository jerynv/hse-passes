import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hse_apps/assets/variables.dart';
import 'package:hse_apps/functions/error.dart';
import 'package:hse_apps/functions/ws.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth {
  static String _LoginId = '';
  static String _LoginBearertoken = '';
  static Map<dynamic, dynamic>? _userData = {};

  static String get loginId => _LoginId;
  static String get loginBearerToken => _LoginBearertoken;
  static Map<dynamic, dynamic>? get userData => _userData;

  static Future<bool> login(String id, String password) async {
    // await Future.delayed(const Duration(seconds: 2));
    if (id.isEmpty || password.isEmpty) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(HTTP_SERVER + '/api'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'operation': 'StudentLogin',
          "data": {
            "id": id,
            "password": password,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];
        debugPrint("data" + data.toString());
        if (token != null && userData != null) {
          _LoginId = id;
          _LoginBearertoken = token;
          _userData = userData;
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  static Future<bool> Tlogin(String id, String password) async {
    // await Future.delayed(const Duration(seconds: 2));
    if (id.isEmpty || password.isEmpty) {
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(HTTP_SERVER + '/api'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'Operation': 'TeacherLogin',
          "Data": {
            "id": id,
            "password": password,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];
        debugPrint("data" + data.toString());
        if (token != null && userData != null) {
          _LoginId = id;
          _LoginBearertoken = token;
          _userData = userData;
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  static Future<void> logout(
      {bool? error, required BuildContext context}) async {
    await WebSocketProvider.close();
    _LoginId = '';
    _LoginBearertoken = '';
    _userData = {};
    debugPrint("Logout: " + error.toString());

    if (error == true || error == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      ShowErrorDialog(
        context,
        "Logout",
        "You have been logged out successfully.",
        "OK",
        Icons.logout,
        Colors.green,
        null,
        () {},
      );
    }
  }
}
