import 'package:flutter/material.dart';
import 'package:otp_boxes/input_box.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({super.key});

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<Color> _boxColors = [Colors.grey, Colors.grey, Colors.grey, Colors.grey];
  final String _targetWord = "TEST"; // The target word to guess
  bool _isSubmitted = false;

  void changeFocus(BuildContext context, String value, int index) {
    if (value.length == 1) {
      if (index < _controllers.length - 1) {
        FocusScope.of(context).nextFocus();
      } else {
        // If it's the last box, check all fields and submit
        if (_areAllFieldsFilled()) {
          _submitValues();
        }
      }
    } else if (value.length == 0 && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  bool _areAllFieldsFilled() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _submitValues() {
    setState(() {
      for (int i = 0; i < _controllers.length; i++) {
        String letter = _controllers[i].text.toUpperCase();
        if (letter == _targetWord[i]) {
          _boxColors[i] = Colors.green; // Correct letter and position
        } else if (_targetWord.contains(letter)) {
          _boxColors[i] = Colors.yellow; // Correct letter but wrong position
        } else {
          _boxColors[i] = Colors.red; // Incorrect letter
        }
      }
      _isSubmitted = true; // Disable further input
    });
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: TextField(
              controller: _controllers[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              enabled: !_isSubmitted, // Disable input after submission
              onChanged: (value) {
                changeFocus(context, value, index);
              },
              onSubmitted: (value) {
                if (_areAllFieldsFilled()) {
                  _submitValues();
                }
              },
              decoration: InputDecoration(
                counterText: '', // Hide character count
                border: OutlineInputBorder(),
                filled: true,
                fillColor: _boxColors[index], // Set box color based on guess
              ),
            ),
          );
        }),
    );
  }
}


