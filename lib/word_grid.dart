import 'package:flutter/material.dart';
import 'package:otp_boxes/input_box.dart';
import 'package:otp_boxes/word_row.dart';

class WordGrid extends StatelessWidget {
  final noOfChances = 6;
  final wordLength = 5;

  const WordGrid({super.key});

  @override
  Widget build(BuildContext context) {

    final rows = List.generate(noOfChances, (_)=> WordRow());
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: rows),
    );
  }
}
