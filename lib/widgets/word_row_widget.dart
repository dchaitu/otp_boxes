import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/widgets/input_box_widget.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';

class WordRowWidget extends ConsumerWidget {
  final int wordLength;
  final int rowIndex;

  const WordRowWidget({super.key, this.wordLength = 5, required this.rowIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(textInputProvider);
    final isActiveRow = rowIndex == state.currentRow;
    final currentWord = isActiveRow
        ? state.currentWord
        : (rowIndex < state.userWords.length ? state.userWords[rowIndex] : '');


    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(wordLength, (index) {
        final letter = index < currentWord.length ? currentWord[index] : '';
        final tileIndex = (rowIndex * wordLength) + index;
        final validation = tileIndex < state.tilesEntered.length
            ? state.tilesEntered[tileIndex].validate
            : TileType.notAnswered;

        final controller = TextEditingController(text: letter);

        return InputBoxWidget(controller: controller,validate: validation, focusNode: FocusNode(),);
      }),
    );
  }
}
