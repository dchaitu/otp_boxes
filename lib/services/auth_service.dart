import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_boxes/constants/variables.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String webClientId = WEB_CLIENT_ID;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: webClientId,
    scopes: [
      'email',
      'profile',
    ],
  );

  // Sign in with Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Initialize SharedPreferences if not already initialized
      await UserDetailsSharedPref.init();
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google Sign-In cancelled');
        return null;
      }

      Map<String, dynamic>? existingUsername = await getExistingUsername(googleUser.id);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);

      return {
        'userCredential': userCredential,
        'username': existingUsername?['username'],
        'token': existingUsername?['token'],
        'email': googleUser.email,
        'googleId': googleUser.id,
      };
    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getExistingUsername(String googleId) async {
    String? username = UserDetailsSharedPref.getUserName();
    String? token = UserDetailsSharedPref.getUserToken();
    if (username != null && username.isNotEmpty && !username.contains('@')&& token != null && token.isNotEmpty) {
      print('Found user in SharedPreferences: $username');
      return {'username': username, 'token': token, 'source': 'shared_prefs'};
    }

    try {
      final response = await http.get(
        Uri.parse('$checkUserUrl?googleId=$googleId'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
        },
      );
      print("response of check user $response");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['username'] != null) {
          final tokenResponse = await http.post(
            Uri.parse(authApiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'username': data['username'],
              'password': googleId,
            }),
          );
          if (tokenResponse.statusCode == 200) {
            final tokenData = jsonDecode(tokenResponse.body);
            await UserDetailsSharedPref.setUserName(data['username']);
            await UserDetailsSharedPref.setToken(tokenData['access']);
            print('Found user in DynamoDB: ${data['username']}');
            return {
              'username': data['username'],
              'token': tokenData['access'],
              'source': 'dynamodb'
            };
          } else {
            print('Failed to get token: ${tokenResponse.statusCode} ${tokenResponse.body}');
            return null;
          }
        }
      }else {
        print('Check user failed: ${response.statusCode} ${response.body}');
      }

    } catch (e) {
      print('Error checking username in DynamoDB with lambda call: $e');
    }
    return null;
  }
}
