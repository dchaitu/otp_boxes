import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otp_boxes/models/login.dart';

class ApiService {
  String wordUrl = 'http://127.0.0.1:8000/word/';
  String loginUrl = 'http://127.0.0.1:8000/login/';
  String signUpUrl = 'http://127.0.0.1:8000/signup/';


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

  Future<Login?> userLogin(String username, String password) async
  {
    try{
      var response = await http.post(Uri.parse(loginUrl),
          body: {"username": username, "password": password});

      if (response.statusCode == 200) {
        return Login.fromJson(jsonDecode(response.body));
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (error) {
      print("Exception: $error");
    }

    return null;
  }

  Future<void> userSignup(String username, String email, String password) async
  {
    try{
      var response = await http.post(Uri.parse(signUpUrl),
          body: {"username": username, "email":email, "password": password});

      if (response.statusCode == 200) {
        print("$username created successfully");
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (error) {
      print("Exception: $error");
    }

  }

}

final wordsFromAPIProvider = Provider<ApiService>((ref) => ApiService());

final getWordFromWordsProvider = FutureProvider<String>((ref) async {
  return ref.watch(wordsFromAPIProvider).getWord();
});
