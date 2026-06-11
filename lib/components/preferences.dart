import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// make a class for the general preferences like show or hide the answer in questions page in list
class GeneralPreference {
  static const SHOW_ANSWER = "SHOWANSWER";
  static const FONT_SIZE = "FONTSIZE";
  static const THEME_COLOR = "THEMECOLOR";

  setAnswerVisibility(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SHOW_ANSWER, value);
  }

  Future<bool> getAnswerVisibility() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SHOW_ANSWER) ?? false;
  }

  setFontSize(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(FONT_SIZE, value);
  }

  Future<double> getFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(FONT_SIZE) ?? 21.0;
  }

  setThemeColor(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(THEME_COLOR, value);
  }

  Future<int> getThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(THEME_COLOR) ?? 0;
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
  double _fontSize = 21.0;
  int _themeColorIndex = 0;

  bool get showAnswer => _showAnswer;

  set showAnswer(bool value) {
    _showAnswer = value;
    generalPreference.setAnswerVisibility(value);
    notifyListeners();
  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    generalPreference.setFontSize(value);
    notifyListeners();
  }

  int get themeColorIndex => _themeColorIndex;

  set themeColorIndex(int value) {
    _themeColorIndex = value;
    generalPreference.setThemeColor(value);
    notifyListeners();
  }

  Future<void> init() async {
    _darkTheme = await darkThemePreference.getTheme();
    _showAnswer = await generalPreference.getAnswerVisibility();
    _fontSize = await generalPreference.getFontSize();
    _themeColorIndex = await generalPreference.getThemeColor();
    notifyListeners();
  }
}
