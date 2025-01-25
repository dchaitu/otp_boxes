import 'package:flutter/material.dart';
import 'package:otp_boxes/widgets/word_row_widget.dart';

class WordGridWidget extends StatelessWidget {
  final int noOfChances;
  final int wordLength;

  const WordGridWidget({super.key, this.noOfChances = 6, this.wordLength = 5});

  @override
  Widget build(BuildContext context) {


    final rows = List.generate(
      noOfChances,
      (index) => WordRowWidget(
        wordLength: wordLength,
        rowIndex: index,
      ),
    );
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center, children: rows);
  }
}
