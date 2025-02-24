import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String token;
  ApiService({required this.token});

  String authApiUrl = 'http://127.0.0.1:8000/api/token/';
  String wordUrl = 'http://127.0.0.1:8000/word/';
  String loginUrl = 'http://127.0.0.1:8000/login/';
  String signUpUrl = 'http://127.0.0.1:8000/signup/';
  String guessedWordUrl = 'http://127.0.0.1:8000/guess/';
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
    } else {
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
      } else {
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

}

final wordsFromAPIProvider = StateProvider<ApiService>((ref) {
  final token = ref.watch(tokenProvider);
  return ApiService(token: token ?? "");
});
final usernameProvider = StateProvider<String>((ref)=> '');
final tokenProvider = StateProvider<String?>((ref) => null);

