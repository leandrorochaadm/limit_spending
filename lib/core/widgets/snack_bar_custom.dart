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
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: duration,
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }
}
