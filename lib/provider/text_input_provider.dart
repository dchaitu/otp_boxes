import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/provider/key_color_provider.dart';

import '../models/tile.dart';

class WordCheck {
  List<String> userWords;
  String actualWord;
  String currentWord;
  bool isWordEntered;
  int noOfChances;
  bool isWon;
  int currentRow;
  List<Tile> tilesEntered;
  Map<String, TileType> keyColors;

  WordCheck(
      {required this.userWords,
      required this.actualWord,
      required this.currentWord,
      required this.isWordEntered,
      required this.noOfChances,
      required this.isWon,
      required this.currentRow,
      required this.tilesEntered,
      required this.keyColors});

  WordCheck copyWith(
      {List<String>? userWords,
      String? actualWord,
      String? currentWord,
      bool? isWordEntered,
      int? noOfChances,
      bool? isWon,
      int? currentRow,
      List<Tile>? tilesEntered,
      Map<String, TileType>? keyColors}) {
    return WordCheck(
        userWords: userWords ?? this.userWords,
        actualWord: actualWord ?? this.actualWord,
        currentWord: currentWord ?? this.currentWord,
        isWordEntered: isWordEntered ?? this.isWordEntered,
        noOfChances: noOfChances ?? this.noOfChances,
        isWon: isWon ?? this.isWon,
        currentRow: currentRow ?? this.currentRow,
        tilesEntered: tilesEntered ?? this.tilesEntered,
        keyColors: keyColors ?? this.keyColors);
  }
}

class TextInputNotifier extends StateNotifier<WordCheck> {
  TextInputNotifier({wordCheck}) : super(wordCheck);

  void addChar(String letter) {
    if (state.currentWord.length < 5) {
      print(state.currentWord);
      state = state.copyWith(
          currentWord: state.currentWord + letter,
          tilesEntered: [
            ...state.tilesEntered,
            Tile(letter: letter, validate: TileType.notAnswered)
          ]);
    }
  }

  void removeChar() {
    if (state.currentWord.isNotEmpty) {
      state = state.copyWith(
          currentWord:
              state.currentWord.substring(0, state.currentWord.length - 1),
          tilesEntered: [
            ...state.tilesEntered.sublist(0, state.tilesEntered.length - 1)
          ]);
    }
  }

  void enterChar(WidgetRef ref) {
    if (state.currentWord.length == 5 && state.noOfChances > 0) {
      List remainingCorrect = state.actualWord.characters.toList();
      if (state.actualWord == state.currentWord) {
        for (int i = 0; i < 5; i++) {
          ref
              .read(keyColorProvider.notifier)
              .updateKeyColor(state.currentWord[i], TileType.correctPosition);
        }

        for (int i = state.currentRow * 5; i < state.currentRow * 5 + 5; i++) {
          state.tilesEntered[i].validate = TileType.correctPosition;
          state.tilesEntered[i].shouldRotate = true;
        }

        state = state.copyWith(
            isWordEntered: true,
            userWords: [...state.userWords, state.currentWord],
            currentWord: '',
            noOfChances: state.noOfChances - 1,
            currentRow: state.currentRow + 1,
            isWon: true,
            keyColors: {...state.keyColors});
        print("Word is ${state.userWords}");
      } else {
        for (int i = 0; i < 5; i++) {
          if (state.currentWord[i] == state.actualWord[i]) {
            // matching other tiles are in correctPosition

            // adding color to the keyboard tile and boxColor
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileType.correctPosition;
            state.keyColors[state.currentWord[i]] = TileType.correctPosition;
          }
        }
        for (int i = 0; i < 5; i++) {
          if (state.currentWord[i] == state.actualWord[i]) {
            {
              // removing matched keys so they won't overlap with present keys.
              remainingCorrect.remove(state.currentWord[i]);
              ref.read(keyColorProvider.notifier).updateKeyColor(
                  state.currentWord[i], TileType.correctPosition);
            }
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileType.correctPosition;
            state.keyColors[state.currentWord[i]] = TileType.correctPosition;
          } else if (remainingCorrect.contains(state.currentWord[i])) {

            // adding color to the keyboard tile and boxColor
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileType.present;
            ref.read(keyColorProvider.notifier)
                .updateKeyColor(state.currentWord[i], TileType.present);
          } else {

            // adding color to the keyboard tile and boxColor
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileType.notPresent;
            ref.read(keyColorProvider.notifier)
                .updateKeyColor(state.currentWord[i], TileType.notPresent);
          }
          state.tilesEntered[i + (state.currentRow * 5)].shouldRotate = true;
        }

        state = state.copyWith(
          isWordEntered: true,
          userWords: [...state.userWords, state.currentWord],
          currentWord: '',
          currentRow: state.currentRow + 1,
          noOfChances: state.noOfChances - 1,
        );
      }
    } else {
      print("Word is not completed");

      state = state.copyWith(isWordEntered: false);
    }
    state = state.copyWith(
      currentWord: '',
      keyColors: {...state.keyColors},
    );
  }

  void resetGameState(WidgetRef ref) {
    final data = ref.watch(getWordFromWordsProvider);
    ref.read(keyColorProvider.notifier).resetColors();
    state = state.copyWith(
        userWords: [],
        actualWord: data.when(
            data: (data) => data,
            error: (error, s) => "ERROR",
            loading: () => "loading..."),
        currentWord: '',
        isWon: false,
        isWordEntered: false,
        noOfChances: 6,
        currentRow: 0,
        tilesEntered: [],
        keyColors: keyColorsMap);
  }
}

final textInputProvider =
    StateNotifierProvider<TextInputNotifier, WordCheck>((ref) {
  final data = ref.watch(getWordFromWordsProvider);

  return TextInputNotifier(
    wordCheck: WordCheck(
        userWords: [],
        actualWord: data.when(
            data: (data) => data,
            error: (error, s) => "ERROR",
            loading: () => "loading..."),
        currentWord: '',
        isWon: false,
        isWordEntered: false,
        noOfChances: 6,
        currentRow: 0,
        tilesEntered: [],
        keyColors: keyColorsMap),
  );
});
