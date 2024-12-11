import 'package:flutter/material.dart';

class SnackBarCustom {
  final String message;
  final bool isError;
  final Duration duration;
  final BuildContext context;

  SnackBarCustom({
    required this.context,
    required this.message,
    required this.isError,
    this.duration = const Duration(seconds: 1),
  }) {
    _call();
  }

  void _call() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center, // Centraliza o texto
          overflow: TextOverflow.ellipsis, // Trunca o texto longo
          maxLines: 1, // Limita o texto a duas linhas
        ),
        duration: duration,
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        // behavior: SnackBarBehavior.floating, // Deixa a SnackBar flutuante
      ),
    );
  }
}
