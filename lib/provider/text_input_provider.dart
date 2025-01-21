import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/enum.dart';

import '../models/tile.dart';

class WordCheck {
  List<String> userWords;
  String actualWord;
  String currentWord;
  bool isMatched;
  bool isWordEntered;
  bool showClues;
  int noOfChances;
  bool isWon;
  int currentRow;
  int currentPosition;
  List<Tile> tilesEntered;
  Map<String, TileValidate> keyColors;

  WordCheck(
      {required this.userWords,
      required this.actualWord,
      required this.currentWord,
      required this.isMatched,
      required this.isWordEntered,
      required this.showClues,
      required this.noOfChances,
      required this.isWon,
      required this.currentRow,
      required this.currentPosition,
      required this.tilesEntered,
      required this.keyColors});

  WordCheck copyWith(
      {List<String>? userWords,
      String? actualWord,
      String? currentWord,
      bool? isMatched,
      bool? isWordEntered,
      bool? showClues,
      int? noOfChances,
      bool? isWon,
      int? currentRow,
      int? currentPosition,
      List<Tile>? tilesEntered,
        Map<String, TileValidate>? keyColors}) {
    return WordCheck(
        userWords: userWords ?? this.userWords,
        actualWord: actualWord ?? this.actualWord,
        currentWord: currentWord ?? this.currentWord,
        isMatched: isMatched ?? this.isMatched,
        showClues: showClues ?? this.showClues,
        isWordEntered: isWordEntered ?? this.isWordEntered,
        noOfChances: noOfChances ?? this.noOfChances,
        isWon: isWon ?? this.isWon,
        currentRow: currentRow ?? this.currentRow,
        currentPosition: currentPosition ?? this.currentPosition,
        tilesEntered: tilesEntered ?? this.tilesEntered,
        keyColors:keyColors?? this.keyColors
    );
  }
}

class TextInputNotifier extends StateNotifier<WordCheck> {
  final TextEditingController controller = TextEditingController();

  TextInputNotifier({wordCheck}) : super(wordCheck);

  void addChar(String letter) {
    if (state.currentWord.length < 5) {
      state = state.copyWith(
          currentWord: state.currentWord + letter,
          currentPosition: state.currentPosition + 1,
          tilesEntered: [
            ...state.tilesEntered,
            Tile(letter: letter, validate: TileValidate.notAnswered)
          ]);
      controller.text = state.currentWord;
      print(letter);

    }
  }

  void removeChar() {
    if (state.currentWord.isNotEmpty) {
      state = state.copyWith(
          currentWord:
              state.currentWord.substring(0, state.currentWord.length - 1),
          currentPosition: state.currentPosition - 1,
          tilesEntered: [
            ...state.tilesEntered.sublist(0, state.tilesEntered.length - 1)
          ]);
      controller.text = state.currentWord;
    }
  }

  void userWon() {
    state = state.copyWith(isWon: true);
  }

  void enterChar() {
    if (state.currentWord.length == 5 && state.noOfChances > 0) {
      List remainingCorrect = state.actualWord.characters.toList();
      if (state.actualWord == state.currentWord) {
        for (int i = state.currentRow * 5; i < state.currentRow * 5 + 5; i++) {
          state.tilesEntered[i].validate = TileValidate.correctPosition;
        }

        state = state.copyWith(
          isWordEntered: true,
          isMatched: true,
          userWords: [...state.userWords, state.currentWord],
          currentWord: '',
          noOfChances: state.noOfChances - 1,
          currentRow: state.currentRow + 1,
          currentPosition: 0,
          isWon: true,
          keyColors: {...state.keyColors}
        );
        print("Word is ${state.userWords}");
      } else {
        for (int i = 0; i < 5; i++) {
          if (state.currentWord[i] == state.actualWord[i]) {
            remainingCorrect.remove(state.currentWord[i]);
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileValidate.correctPosition;
            state.keyColors[state.currentWord[i]] = TileValidate.correctPosition;

          }
        }
        for (int i = 0; i < 5; i++) {
          if (state.currentWord[i] == state.actualWord[i]) {
            remainingCorrect.remove(state.currentWord[i]);
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileValidate.correctPosition;
            state.keyColors[state.currentWord[i]] = TileValidate.correctPosition;
          } else if (remainingCorrect.contains(state.currentWord[i])) {
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileValidate.present;
            state.keyColors[state.currentWord[i]] = TileValidate.present;
          } else {
            state.tilesEntered[i + (state.currentRow * 5)].validate =
                TileValidate.notPresent;
            state.keyColors[state.currentWord[i]] = TileValidate.notPresent;
          }
        }

        state = state.copyWith(
          isWordEntered: true,
          isMatched: false,
          userWords: [...state.userWords, state.currentWord],
          currentWord: '',
          showClues: true,
          currentRow: state.currentRow + 1,
          noOfChances: state.noOfChances - 1,
          currentPosition: 0,
        );
      }
    } else {
      print("Word is not completed");
      state = state.copyWith(isWordEntered: false);
    }
    controller.clear();
    state = state.copyWith(
      currentWord: '',
      keyColors: {...state.keyColors},
    );
  }

  void resetGameState(WidgetRef ref) {
    final data = ref.watch(userDataProvider);
    state = state.copyWith(
      userWords: [],
      actualWord: data.when(
          data: (data) => data,
          error: (error, s) => "ERROR",
          loading: () => "loading..."),
      currentWord: '',
      isWon: false,
      isMatched: false,
      isWordEntered: false,
      showClues: false,
      noOfChances: 6,
      currentPosition: 0,
      currentRow: 0,
      tilesEntered: [],
    );
  }
}

final textInputProvider =
    StateNotifierProvider<TextInputNotifier, WordCheck>((ref) {
  final data = ref.watch(userDataProvider);

  return TextInputNotifier(
    wordCheck: WordCheck(
        userWords: [],
        actualWord: data.when(
            data: (data) => data,
            error: (error, s) => "ERROR",
            loading: () => "loading..."),
        currentWord: '',
        isWon: false,
        isMatched: false,
        isWordEntered: false,
        showClues: false,
        noOfChances: 6,
        currentRow: 0,
        currentPosition: 0,
        tilesEntered: [],
        keyColors: keyColorsMap),
  );
});

class ApiService {
  String wordUrl = 'http://127.0.0.1:8000/word/';

  Future<String> getWord() async {
    final response = await http.get(Uri.parse(wordUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var word = jsonData['word'];
      return word;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final userWordProvider = Provider<ApiService>((ref) => ApiService());

final userDataProvider = FutureProvider<String>((ref) async {
  return ref.watch(userWordProvider).getWord();
});
