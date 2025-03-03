import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otp_boxes/main.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

class ApiService {
  final String token;
  ApiService({required this.token});

  String mainUrl = 'http://127.0.0.1:8080';
  String get authApiUrl => '$mainUrl/api/token/';
  String get wordUrl => '$mainUrl/word/';
  String get loginUrl => '$mainUrl/login/';
  String get signUpUrl => '$mainUrl/signup/';
  String get guessedWordUrl => '$mainUrl/guess/';
  String get correctWordUrl => '$mainUrl/correct/';
  // String token = '';


  Future<void> getWord() async {
    print("current token: $token");
    final response = await http.get(Uri.parse(wordUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      print("Word fetched successfully: ${response.body}");
    } else {
      print("Error fetching word: ${response.statusCode} - ${response.body}");
    // token may expired need to remove it
      UserDetailsSharedPref.setToken('');
    }

  }

  Future<Map<String,dynamic>?> getToken(String username,String password) async{
    var tokenResponse = await http.post(
      Uri.parse(authApiUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"username": username, "password": password}),
    );
    if (tokenResponse.statusCode == 200) {
      var tokenDict = jsonDecode(tokenResponse.body) as Map<String, dynamic>;
      print("access token is  ${tokenDict["access"]}");
      return tokenDict;
    }

    else if(tokenResponse.statusCode ==401){
    //   Need to write code to redirect
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);

    }

    else {
      print("Error: ${tokenResponse.statusCode} - ${tokenResponse.body}");
    }
    return null;

  }

  Future<Map<String, dynamic>?> storeCurrentWord(String username, String currentWord) async
  {
    print("getCurrentWord $username, $currentWord");
    try{
      var response = await http.post(
          Uri.parse(guessedWordUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({"username": username, "content": currentWord}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }else if(response.statusCode ==401){
        navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);

      }

      else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Exception: $error");
    }

    return null;
  }

  Future<Map<String, dynamic>?> userLogin(String username, String password) async
  {
    try{
      var response = await http.post(Uri.parse(loginUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode({"username": username, "password": password})

      );


      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
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
  Future<String> getCorrectWord() async
  {
    print("current token: $token");
    final response = await http.get(Uri.parse(correctWordUrl),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      print("Word fetched successfully: ${response.body}");
      var word = jsonDecode(response.body) as Map<String, dynamic>;
      return word["answer"];
    } else {
      print("Error fetching word: ${response.statusCode} - ${response.body}");
    }
    return "";
  }

}


final wordsFromAPIProvider = StateProvider<ApiService>((ref) {
  final token = UserDetailsSharedPref.getUserToken();
  return ApiService(token: token ?? "");
});

