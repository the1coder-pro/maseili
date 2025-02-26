import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// make a class for the general preferences like show or hide the answer in questions page in list
class GeneralPreference {
  static const SHOW_ANSWER = "SHOWANSWER";

  setAnswerVisibility(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SHOW_ANSWER, value);
  }

  Future<bool> getAnswerVisibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHOW_ANSWER) ?? false;
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class GeneralPrefrencesProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  GeneralPreference generalPreference = GeneralPreference();
  bool _showAnswer = true;

  bool get showAnswer => _showAnswer;

  set showAnswer(bool value) {
    _showAnswer = value;
    generalPreference.setAnswerVisibility(value);
    notifyListeners();
  }
}
