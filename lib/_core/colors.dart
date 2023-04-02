import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor white =
      MaterialColor(_whitePrimaryValue, <int, Color>{
    50: Color(0xFFFDFDFD),
    100: Color(0xFFF9F9FB),
    200: Color(0xFFF5F5F9),
    300: Color(0xFFF1F1F6),
    400: Color(0xFFEEEEF4),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFE9E9F0),
    700: Color(0xFFE5E5EE),
    800: Color(0xFFE2E2EC),
    900: Color(0xFFDDDDE8),
  });
  static const int _whitePrimaryValue = 0xFFEBEBF2;

  static const MaterialColor whiteAccent =
      MaterialColor(_whiteAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_whiteAccentValue),
    400: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
  });
  static const int _whiteAccentValue = 0xFFFFFFFF;

  static const MaterialColor grey =
      MaterialColor(_greyPrimaryValue, <int, Color>{
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF2F2F4),
    200: Color(0xFFE9E9EC),
    300: Color(0xFFE0E0E4),
    400: Color(0xFFD9D9DF),
    500: Color(_greyPrimaryValue),
    600: Color(0xFFCDCDD5),
    700: Color(0xFFC7C7CF),
    800: Color(0xFFC1C1CA),
    900: Color(0xFFB6B6C0),
  });
  static const int _greyPrimaryValue = 0xFFD2D2D9;

  static const MaterialColor greyAccent =
      MaterialColor(_greyAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_greyAccentValue),
    400: Color(0xFFFFFFFF),
    700: Color(0xFFFCFCFF),
  });
  static const int _greyAccentValue = 0xFFFFFFFF;

  static const MaterialColor blue =
      MaterialColor(_bluePrimaryValue, <int, Color>{
    50: Color(0xFFEDF0F4),
    100: Color(0xFFD3D9E4),
    200: Color(0xFFB6C0D3),
    300: Color(0xFF99A6C1),
    400: Color(0xFF8393B3),
    500: Color(_bluePrimaryValue),
    600: Color(0xFF65789E),
    700: Color(0xFF5A6D95),
    800: Color(0xFF50638B),
    900: Color(0xFF3E507B),
  });
  static const int _bluePrimaryValue = 0xFF6D80A6;

  static const MaterialColor blueAccent =
      MaterialColor(_blueAccentValue, <int, Color>{
    100: Color(0xFFCFDDFF),
    200: Color(_blueAccentValue),
    400: Color(0xFF6995FF),
    700: Color(0xFF5083FF),
  });
  static const int _blueAccentValue = 0xFF9CB9FF;

  static const MaterialColor darkfgreen =
      MaterialColor(_darkfgreenPrimaryValue, <int, Color>{
    50: Color(0xFFE2E5E4),
    100: Color(0xFFB6BEBC),
    200: Color(0xFF859390),
    300: Color(0xFF546764),
    400: Color(0xFF304742),
    500: Color(_darkfgreenPrimaryValue),
    600: Color(0xFF0A221D),
    700: Color(0xFF081C18),
    800: Color(0xFF061714),
    900: Color(0xFF030D0B),
  });
  static const int _darkfgreenPrimaryValue = 0xFF0B2621;

  static const MaterialColor darkfgreenAccent =
      MaterialColor(_darkfgreenAccentValue, <int, Color>{
    100: Color(0xFF51FFDC),
    200: Color(_darkfgreenAccentValue),
    400: Color(0xFF00EABB),
    700: Color(0xFF00D0A7),
  });
  static const int _darkfgreenAccentValue = 0xFF1EFFD2;

  static const MaterialColor darkgrey =
      MaterialColor(_darkgreyPrimaryValue, <int, Color>{
    50: Color(0xFFE5E5E4),
    100: Color(0xFFBEBEBB),
    200: Color(0xFF93938E),
    300: Color(0xFF676760),
    400: Color(0xFF47473E),
    500: Color(_darkgreyPrimaryValue),
    600: Color(0xFF222219),
    700: Color(0xFF1C1C14),
    800: Color(0xFF171711),
    900: Color(0xFF0D0D09),
  });
  static const int _darkgreyPrimaryValue = 0xFF26261C;

  static const MaterialColor darkgreyAccent =
      MaterialColor(_darkgreyAccentValue, <int, Color>{
    100: Color(0xFFFFFF53),
    200: Color(_darkgreyAccentValue),
    400: Color(0xFFECEC00),
    700: Color(0xFFD3D300),
  });
  static const int _darkgreyAccentValue = 0xFFFFFF20;

  static Color darkRed = const Color(0xFF8b0000);
  static Color happyGreen = const Color.fromARGB(255, 0, 139, 5);
}
