import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';

Future<Map<String, dynamic>?> userLoginWithToken(String username, String password, BuildContext context, WidgetRef ref) async {
  Map<String, dynamic>? tokenResponse =
  await ApiService(token: '').getToken(username, password);

  if(tokenResponse!=null && tokenResponse["access"]!=null) {
    print("User saved");
    Future.delayed(Duration.zero, () {
      ref.read(tokenProvider.notifier).state = tokenResponse["access"].toString();
      ref.read(usernameProvider.notifier).state = username;
    });
    var resp = await ref.read(wordsFromAPIProvider)
        .userLogin(username, password);
    print("resp is ${resp}");
    return tokenResponse;
  }
  return null;
}