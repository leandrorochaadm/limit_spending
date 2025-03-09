import 'package:flutter/material.dart';

import 'page_translation_builder.dart';

class ThemeDataCustom {
  ThemeDataCustom._();
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.teal, // Cor principal
      onPrimary: Colors.white, // Cor do texto e ícones sobre o fundo principal
      secondary: Colors.tealAccent, // Cor de destaque
      onSecondary: Colors.black, // Cor do texto sobre o fundo
      surface: Colors.grey[900]!, // Cor de superfícies como cards
      onSurface: Colors.white, // Cor do texto sobre superfícies
      error: Colors.red, // Cor para erros
      onError: Colors.white, // Cor do texto sobre fundos de erro
    ),
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
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.grey,
      contentTextStyle: TextStyle(color: Colors.white, fontSize: 14),
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        shape: const StadiumBorder(),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        shape: WidgetStateProperty.all(
          const StadiumBorder(),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.black12; // Cor ao pressionar
          }
          return Colors.white; // Cor padrão
        }),
        foregroundColor: WidgetStateProperty.all(Colors.teal),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.teal), // Cor do texto
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.teal.withValues(alpha: 0.2); // Cor ao pressionar
          }
          return null;
        }),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      iconColor: Colors.teal,
      textColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      subtitleTextStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 18,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.grey.shade900,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    dialogTheme: DialogTheme(backgroundColor: Colors.grey.shade900),
  );
}
