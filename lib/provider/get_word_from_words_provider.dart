import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:otp_boxes/constants/variables.dart';
import 'package:otp_boxes/main.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

class ApiService {
  final String token;
  ApiService({required this.token});

  Future<String?> _getAppCheckToken() async {
    try {
      final firebase_token = await FirebaseAppCheck.instance.getToken();
      print("App Check token :$firebase_token");
      return firebase_token;
    }
    catch (e){
      print("Error in AppCheck token: $e");
      return null;
    }
  }


  Future<void> getWord() async {
    final currentToken = UserDetailsSharedPref.getUserToken() ?? "";
    print("current token: $currentToken");

    if (currentToken.isEmpty) {
      print("Error: No token available");
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
      return;
    }

    final appCheckToken = await _getAppCheckToken();
    if (appCheckToken == null) {
      print("Error: No app check token available");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Failed to verify app integrity. Please try again later.')),
      );
      navigatorKey.currentState!.pushNamedAndRemoveUntil('/login', (route) => false);
      return;
    }

    try{
      final response = await http.get(
        Uri.parse(wordUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": 'Bearer $currentToken',
          "X-Firebase-AppCheck": appCheckToken
        },
      );
      print("Response getWord status code: ${response.body}");
      if (response.statusCode == 200) {
        print("Word fetched successfully: ${response.body}");
      } else {
        print("Error fetching word: ${response.statusCode} - ${response.body}");
        if (response.statusCode == 401 || response.statusCode == 403) {
          navigatorKey.currentState!
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
      }
    }
    catch (e){
      print("Error in getWord: $e");
    }
  }

  Future<Map<String, dynamic>?> getToken(
      String username, String password) async {

    final appCheckToken = await _getAppCheckToken();
    if (appCheckToken == null) {
      print("Error: No App Check token available");
      return null;
    }

    try{
      var tokenResponse = await http.post(
        Uri.parse(authApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-Firebase-AppCheck": appCheckToken
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
        await UserDetailsSharedPref.setToken(tokenDict['access']);
        return tokenDict;
      } else if (tokenResponse.statusCode == 401) {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        print("Error: ${tokenResponse.statusCode} - ${tokenResponse.body}");
      }
    }
    catch (e){
      print("Error in getToken: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> storeCurrentWord(
      String username, String currentWord) async {
    print("getCurrentWord $username, $currentWord");
    final currentToken = UserDetailsSharedPref.getUserToken() ?? "";
    final appCheckToken = await _getAppCheckToken();

    if (currentToken.isEmpty || appCheckToken==null) {
      print("Error: No token available");
      return null;
    }

    try {
      var response = await http.post(
        Uri.parse(guessedWordUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": 'Bearer $currentToken',
          "X-Firebase-AppCheck": appCheckToken
        },
        body: jsonEncode({"username": username, "content": currentWord}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Exception in storeCurrentWord: $error");
    }

    return null;
  }

  Future<Map<String, dynamic>?> userLogin(
      String username, String password) async {
    final appCheckToken = await _getAppCheckToken();
    if (appCheckToken == null) {
      print("Error: No App Check token available");
      return null;
    }

    try {
      var response = await http.post(Uri.parse(loginUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Firebase-AppCheck": appCheckToken
          },
          body: jsonEncode({"username": username, "password": password}));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['access'] != null) {
          await UserDetailsSharedPref.setToken(data['access']);
        }
        return data;
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (error) {
      print("Exception in userLogin: $error");
    }

    return null;
  }

  Future<Map<String, dynamic>?> userSignup(
      String username, String email, String password,
      {bool isGoogleSignup = false}) async {
    final appCheckToken = await _getAppCheckToken();
    if (appCheckToken == null) {
      print("Error: No App Check token available");
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse(signUpUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-Firebase-AppCheck": appCheckToken
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "googleId": isGoogleSignup ? password : '',
          "password": isGoogleSignup ? '' : password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("$username created successfully");
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['access'] != null) {
          await UserDetailsSharedPref.setToken(data['access']);
        }
        return data;
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (error) {
      print("Exception: $error");
      return null;
    }
  }

  Future<String> getCorrectWord() async {
    var currentToken = UserDetailsSharedPref.getUserToken() ?? "";
    final appCheckToken = await _getAppCheckToken();
    if (currentToken.isEmpty || appCheckToken==null) {
      print("Error: Token is empty or null.");
      return "";
    }
    try {
      final response = await http.get(
        Uri.parse(correctWordUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": 'Bearer $currentToken',
          "X-Firebase-AppCheck": appCheckToken
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
    catch(e){
      print("Error in getCorrectWord: $e");
    }
    return "";
  }
}

final wordsFromAPIProvider = StateProvider<ApiService>((ref) {
  final token = UserDetailsSharedPref.getUserToken();
  return ApiService(token: token ?? "");
});
