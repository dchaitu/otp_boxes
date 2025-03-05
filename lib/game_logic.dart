import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/main.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

Future<String> getJwtToken(String username, String password) async {
  var currentToken = await UserDetailsSharedPref.getUserToken()??"";
  Map<String, dynamic>? tokenResponse =
      await ApiService(token: currentToken).getToken(username, password);
  var newToken = tokenResponse!["access"];
  if(currentToken!=newToken) {
    print("updating token  : $tokenResponse");
    await UserDetailsSharedPref.setToken(newToken);
    await UserDetailsSharedPref.setUserName(username);
    print("Getting token $newToken");
    return newToken;
  }
  return currentToken;

}


Future<Map<String, dynamic>?> userLoginWithToken(
    String username, String password, BuildContext context, WidgetRef ref
    ) async {
  String? token = await UserDetailsSharedPref.getUserToken();
  if(token!.isEmpty) {
    var loginResp =
    await ref.read(wordsFromAPIProvider).userLogin(username, password);
    if (loginResp != null && loginResp["access"] != null) {
      print("User saved");
      Future.delayed(Duration.zero, () {
        ref.read(usernameProvider.notifier).state = username;
      });

      print("resp is ${loginResp}");
      return loginResp;
    }
  }
  return null;
}


Future<void> userSignOut()  async {
  await UserDetailsSharedPref.setToken("");
  await UserDetailsSharedPref.setUserName("");
  navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
}