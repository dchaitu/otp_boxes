import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputBox extends StatelessWidget {
  final ValueChanged onChanged;

  const InputBox({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all(width: 2, color: Colors.grey)),
      height: 64,
      width: 64,
      child: TextField(
        onChanged: onChanged,
        style: Theme.of(context).textTheme.headlineMedium,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
      ),
    );
  }
}
