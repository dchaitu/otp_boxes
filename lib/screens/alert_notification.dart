import 'package:flutter/material.dart';

class AlertNotification extends StatelessWidget {
  final String message;
  const AlertNotification({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message, textAlign: TextAlign.center),
    );
  }
}
