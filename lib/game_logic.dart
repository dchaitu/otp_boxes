import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/main.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
import 'package:otp_boxes/screens/stats_dialog.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

Future<String> getJwtToken(String username, String password) async {
  var currentToken = UserDetailsSharedPref.getUserToken()??"";
  Map<String, dynamic>? tokenResponse =
      await ApiService(token: currentToken).getToken(username, password);
  var newToken = tokenResponse!["access"];
  if(currentToken!=newToken || currentToken.isEmpty) {
    await UserDetailsSharedPref.setToken(newToken);
    await UserDetailsSharedPref.setUserName(username);
    return newToken;
  }
  return currentToken;

}


Future<Map<String, dynamic>?> userLoginWithToken(
    String username, String password, BuildContext context, WidgetRef ref
    ) async {
  try{
    var loginResp = await ref.read(wordsFromAPIProvider).getToken(username, password);
    if(loginResp != null && loginResp["access"] != null) {
      String newToken = loginResp["access"];
      await UserDetailsSharedPref.setToken(newToken);
      await UserDetailsSharedPref.setUserName(username);
      ref.read(usernameProvider.notifier).state = username;
      print("Username $username, is setting for usernameProvider");
      return loginResp;

    }
  }
  catch(e){
    print("Error logging:- $e");
  }
  return null;
}


Future<void> userSignOut()  async {
  print("User Sign Out");
  await UserDetailsSharedPref.setToken("");
  await UserDetailsSharedPref.setUserName("");
  navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
}

void gameConditions(WidgetRef ref, BuildContext newContext) {
  final bool isWonTextInput = ref.watch(textInputProvider).isWon;
  final int noOfChances = ref.read(textInputProvider).noOfChances;

  print("noOfChances $noOfChances");
  if (isWonTextInput&& noOfChances>=4) {
    showPrompt(newContext, "IMPRESSIVE!");
    Future.delayed(const Duration(milliseconds: 3000), () {
      handleCaseCorrect(newContext);
    });
  }
  else if (isWonTextInput&& noOfChances==3) {
    showPrompt(newContext, "SPLENDID!");
    Future.delayed(const Duration(milliseconds: 3000), () {
      handleCaseCorrect(newContext);
    });
  }
  else if (isWonTextInput&& noOfChances==2) {
    showPrompt(newContext, "NICE!");
    Future.delayed(const Duration(milliseconds: 3000), () {
      handleCaseCorrect(newContext);
    });
  }
  else if (isWonTextInput&& noOfChances==1) {
    showPrompt(newContext, "EEPE!");
    Future.delayed(const Duration(milliseconds: 3000), () {
      handleCaseCorrect(newContext);
    });
  }
  if (noOfChances == 0) {
    print("Prompt should display");
    showPrompt(newContext, "OOPS!");
    Future.delayed(const Duration(milliseconds: 3000), () async {
      var answer = await ref.read(wordsFromAPIProvider).getCorrectWord();
      print("Word is $answer");
      showPrompt(newContext, answer);
      handleCaseCorrect(newContext);
    });

  }

}

void handleCaseCorrect(BuildContext context) {
  Future.delayed(const Duration(seconds: 2), () {
    showDialog(context: context, builder: (context) => const StatsDialog());
  });
}

void showPrompt(BuildContext context, String message) {
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).maybePop();
            }
          });
        });
        return AlertDialog(
          title: Text(message, textAlign: TextAlign.center),
        );
      });
}