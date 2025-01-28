import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/animations/bounce_animation.dart';
import 'package:otp_boxes/animations/dance_animation.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/constants/variables.dart';
import 'package:otp_boxes/widgets/input_box_widget.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/animations/rotating_tile_animation.dart';

class WordRowWidget extends ConsumerWidget {
  final int wordLength;
  final int rowIndex;

  const WordRowWidget(
      {super.key, this.wordLength = EACH_WORD_LENGTH, required this.rowIndex});

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
        // print("tileIndex:- $tileIndex, ");
        final shouldRotate = tileIndex < state.tilesEntered.length
            ? state.tilesEntered[tileIndex].shouldRotate
            : false;
        final isWon = state.isWon;

        final controller = TextEditingController(text: letter);
        final bounce = tileIndex == state.tilesEntered.length - 1;
        int danceDelay = 1500;
        bool isDancing = false;
        return RotatingTileAnimation(
          shouldRotate: shouldRotate,
          duration:
              Duration(milliseconds: 300 * (index - state.currentRow + 1)),
          delay: index.toDouble(),
          childBuilder: (double flipValue) {
            if (isWon) {
              for (int i = state.tilesEntered.length - 5;
                  i < state.tilesEntered.length;
                  i++) {
                if (tileIndex == i) {
                  isDancing = true;
                  danceDelay += 200 * (i - (state.currentRow - 1) * 3);
                }
              }
            }

            return DanceAnimation(
              isDancing: isDancing,
              delay: danceDelay,
              child: BounceAnimation(
                bounce: bounce,
                child: InputBoxWidget(
                  controller: controller,
                  validate: validation,
                  focusNode: FocusNode(),
                  flipValue: flipValue,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
