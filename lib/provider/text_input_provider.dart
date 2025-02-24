import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/provider/key_color_provider.dart';

import '../models/tile.dart';

class WordCheck {
  List<String> userWords;
  String currentWord;
  bool isWordEntered;
  int noOfChances;
  bool isWon;
  int currentRow;
  List<Tile> tilesEntered;
  Map<String, TileType> keyColors;
  bool backBounce = false;

  WordCheck(
      {required this.userWords,
      required this.currentWord,
      required this.isWordEntered,
      required this.noOfChances,
      required this.isWon,
      required this.currentRow,
      required this.tilesEntered,
      required this.keyColors,
      required this.backBounce});

  WordCheck copyWith(
      {List<String>? userWords,
      String? currentWord,
      bool? isWordEntered,
      int? noOfChances,
      bool? isWon,
      int? currentRow,
      List<Tile>? tilesEntered,
        Map<String, TileType>? keyColors,
      bool? backBounce}) {
    return WordCheck(
        userWords: userWords ?? this.userWords,
        currentWord: currentWord ?? this.currentWord,
        isWordEntered: isWordEntered ?? this.isWordEntered,
        noOfChances: noOfChances ?? this.noOfChances,
        isWon: isWon ?? this.isWon,
        currentRow: currentRow ?? this.currentRow,
        tilesEntered: tilesEntered ?? this.tilesEntered,
        keyColors:keyColors?? this.keyColors,
        backBounce:backBounce?? this.backBounce
    );
  }
}

class TextInputNotifier extends StateNotifier<WordCheck> {

  TextInputNotifier({wordCheck}) : super(wordCheck);

  void addChar(String letter) {
    if (state.currentWord.length < 5) {
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

  void userWon() {
    state = state.copyWith(isWon: true);
  }

  void enterChar(WidgetRef ref) async {
    print("state.currentWord ${state.currentWord}, state.noOfChances ${state.noOfChances}");

    if (state.currentWord.length == 5 && state.noOfChances > 0) {
      print("Calling getCurrentWord API...");

      try {
        var username =ref.read(usernameProvider.notifier).state;
        var responseBody = await ref.read(wordsFromAPIProvider).storeCurrentWord(username, state.currentWord);

        if (responseBody != null && responseBody.containsKey("data")) {
          var data = responseBody["data"] as Map<String, dynamic>;
          print("API Response: $data");

          List<Tile> updatedTiles = List.from(state.tilesEntered);

          for (int i = 0; i < 5; i++) {
            String letter = state.currentWord[i];

            TileType tileType = getTileType(data[i.toString()]);

            // Update tiles
            updatedTiles[i + (state.currentRow * 5)] = Tile(
              letter: letter,
              validate: tileType,
              shouldRotate: true,
            );

            // Update key colors
            ref.read(keyColorProvider.notifier).updateKeyColor(letter, tileType);
          }

          // Update state after processing API response
          state = state.copyWith(
            isWordEntered: true,
            userWords: [...state.userWords, state.currentWord],
            currentWord: '',
            currentRow: state.currentRow + 1,
            noOfChances: state.noOfChances - 1,
            tilesEntered: updatedTiles,
          );

          // Check if user won
          if (data.values.every((val) => val == "correctPosition")) {
            userWon();
          }
        } else {
          print("Invalid API response: $responseBody");
        }
      } catch (error) {
        print("Error calling API: $error");
      }
    } else {
      print("Word is not completed");
      state = state.copyWith(isWordEntered: false);
    }
  }


  void resetGameState(WidgetRef ref) {
    ref.read(keyColorProvider.notifier).resetColors();
    state = state.copyWith(
      userWords: [],
      currentWord: '',
      isWon: false,
      isWordEntered: false,
      noOfChances: 6,
      currentRow: 0,
      tilesEntered: [],
      keyColors: keyColorsMap,
        backBounce:false
    );
  }

  void addBackBounce() {
    state = state.copyWith(backBounce: true);
  }

}


final textInputProvider =
    StateNotifierProvider<TextInputNotifier, WordCheck>((ref) {

  return TextInputNotifier(
    wordCheck: WordCheck(
        userWords: [],
        currentWord: '',
        isWon: false,
        isWordEntered: false,
        noOfChances: 6,
        currentRow: 0,
        tilesEntered: [],
        keyColors: keyColorsMap,
        backBounce:false),
  );
});

