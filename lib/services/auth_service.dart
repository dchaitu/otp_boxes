import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp_boxes/constants/variables.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Find the Web Client ID (it should look like: xxxxx-xxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com)
  static const String webClientId = '415880282002-qas8bl22h74gdk4g0qjuvqpr1trdunst.apps.googleusercontent.com';
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: webClientId,
    scopes: [
      'email',
      'profile',
    ],
  );
  Future<String?> getExistingUsername(String googleId) async {
    // Option 1: Check SharedPreferences
    String? username = UserDetailsSharedPref.getUserName();
    if (username != null && username.isNotEmpty && !username.contains('@')) {
      return username; // Return username if it exists and is not an email
    }

    // Option 2: Check DynamoDB via an API call
    try {
      final response = await http.get(
        Uri.parse('$mainUrl/check-user?googleId=$googleId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['username'] != null) {
          await UserDetailsSharedPref.setUserName(data['username']);
          return data['username'];
        }
      }
    } catch (e) {
      print('Error checking username in DynamoDB: $e');
    }
    return null;
  }

  // Sign in with Google
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Initialize SharedPreferences if not already initialized
      await UserDetailsSharedPref.init();
      
      // Sign out first to ensure a clean state
      await _googleSignIn.signOut();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;
      String? existingUsername = await getExistingUsername(googleUser.id);

      // Save the user's email before proceeding with authentication
      // await UserDetailsSharedPref.setUserName(googleUser.email);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await _auth.signInWithCredential(credential);

      return {
        'userCredential': userCredential,
        'username': existingUsername,
        'email': googleUser.email,
        'googleId': googleUser.id,
      };

    } catch (e) {
      print('Error signing in with Google: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
