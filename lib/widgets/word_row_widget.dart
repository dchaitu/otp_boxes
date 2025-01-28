import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/animations/bounce_widget.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/constants/variables.dart';
import 'package:otp_boxes/widgets/input_box_widget.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/animations/rotating_tile_widget.dart';

class WordRowWidget extends ConsumerWidget {
  final int wordLength;
  final int rowIndex;

  const WordRowWidget({super.key, this.wordLength = EACH_WORD_LENGTH, required this.rowIndex});

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
        print("state.tilesEntered.length ${state.tilesEntered.length}");
        print("tileIndex:- $tileIndex, ");
        final shouldRotate = tileIndex < state.tilesEntered.length
            ? state.tilesEntered[tileIndex].shouldRotate
            : false;

        final controller = TextEditingController(text: letter);
        final bounce = tileIndex == state.tilesEntered.length - 1;


          return RotatingTileWidget(
            shouldRotate: shouldRotate,
            duration: Duration(milliseconds: 300*(index-state.currentRow+1) ),
            delay: index.toDouble(),
            childBuilder: (double flipValue) {
              return BounceWidget(
                bounce: bounce,
                child: InputBoxWidget(
                    controller: controller,
                    validate: validation,
                    focusNode: FocusNode(),
                flipValue: flipValue),
              );
            },
          );
      }),
    );
  }
}
