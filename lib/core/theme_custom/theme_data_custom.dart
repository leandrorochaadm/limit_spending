import 'package:flutter/material.dart';

import 'page_translation_builder.dart';

class ThemeDataCustom {
  ThemeDataCustom._();
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal.shade900,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      elevation: 10,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.grey,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: PageTransitionBuilderCustom(),
        TargetPlatform.iOS: PageTransitionBuilderCustom(),
      },
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
