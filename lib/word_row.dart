import 'package:flutter/material.dart';
import 'package:otp_boxes/input_box.dart';

class WordRow extends StatelessWidget {
  final wordLength = 5;

  const WordRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<InputBox> boxes = List.empty(growable: true);

    for (int j = 0; j < wordLength; j++) {
      boxes.add(InputBox(onChanged: (value) {
        print("$value");
      }));
    }
    return Row(mainAxisSize: MainAxisSize.min, children: boxes);
  }
}
