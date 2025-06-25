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