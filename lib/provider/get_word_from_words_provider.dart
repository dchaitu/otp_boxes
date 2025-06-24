import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otp_boxes/main.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

class ApiService {
  final String token;
  ApiService({required this.token});

  String mainUrl = 'https://jctmglxoe8.execute-api.us-east-1.amazonaws.com/testing';
  String get authApiUrl => '$mainUrl/api/token/';
  String get wordUrl => '$mainUrl/word/';
  String get loginUrl => '$mainUrl/login/';
  String get signUpUrl => '$mainUrl/signup';
  String get guessedWordUrl => '$mainUrl/guess/';
  String get correctWordUrl => '$mainUrl/correct/';
  // String token = '';


  Future<void> getWord() async {
    // print("current token: $token");
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
    //   print("UserToken is ${UserDetailsSharedPref.getUserToken()} ");
      // UserDetailsSharedPref.setToken('');
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
      if (!tokenDict.containsKey("access")) {
        print("Missing token in response");
        return null;
      }
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
            "Token": token
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

  Future<Map<String, dynamic>?> userSignup(String username, String email, String password, {bool isGoogleSignup = false}) async {
    try {
      final response = await http.post(
        Uri.parse('$signUpUrl/'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "is_google_signup": isGoogleSignup,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("$username created successfully");
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (error) {
      print("Exception: $error");
      return null;
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      print("Check Username $token");
      final response = await http.get(
        Uri.parse('$signUpUrl?user=$username'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['exists'] ?? false;
      }
      return false;
    } catch (error) {
      print("Error checking username: $error");
      return false;
    }
  }
  Future<String> getCorrectWord() async
  {
    // print("current token: $token");
    var currentToken = await UserDetailsSharedPref.getUserToken()??"";
    if (currentToken.isEmpty) {
      print("Error: Token is empty or null.");
      return "";
    }
    else {
      final response = await http.get(
        Uri.parse(correctWordUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $currentToken'
        },
      );
      if (response.statusCode == 200) {
        print("Word fetched successfully: ${response.body}");
        var word = jsonDecode(response.body) as Map<String, dynamic>;
        return word["answer"];
      } else {
        print("Error fetching word: ${response.statusCode}");
      }
      return "";
    }
  }

}


final wordsFromAPIProvider = StateProvider<ApiService>((ref) {
  final token = UserDetailsSharedPref.getUserToken();
  return ApiService(token: token ?? "");
});

