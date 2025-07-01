import 'package:flutter/material.dart';

void showErrorMessage(String message, BuildContext context, bool mounted) {
  if (!mounted) return;

  // Ensure we have a Scaffold in the widget tree
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red[700],
    ),
  );
}

void showSuccessMessage(String message, BuildContext context, bool mounted) {
  if (!mounted) return;

  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.clearSnackBars();
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[700],
    ),
  );
}







