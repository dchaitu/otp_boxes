import 'package:flutter/material.dart';
import 'package:otp_boxes/word_row.dart';

class WordGrid extends StatelessWidget {
  final int noOfChances;
  final int wordLength;

  const WordGrid({super.key, this.noOfChances = 6, this.wordLength = 5});

  @override
  Widget build(BuildContext context) {
    final rows = List.generate(
      noOfChances,
      (index) => WordRow(
        wordLength: wordLength,
        rowIndex: index,
      ),
    );
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: rows);
  }
}
