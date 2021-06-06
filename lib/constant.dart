import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  static const IS_LOGIN = "IS_LOGIN";
  static const USER_ID = "USER_ID";
  static const USER_EMAIL = "USER_EMAIL";
  static const USER_MOBILE = "USER_MOBILE";
  static const USER_NAME = "USER_NAME";

  static Future<String> getStringPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<bool> setStringPreference(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<int> getIntgerPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<bool> setIntegerPreference(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setInt(key, value);
  }

  static Future<bool> setBooleanPreference(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<bool> getBooleanPreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<bool> clearSharedPreference(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }
}