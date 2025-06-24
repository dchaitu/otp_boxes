import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initialize SharedPreferences if not already initialized
      await UserDetailsSharedPref.init();
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      // Save the user's email before proceeding with authentication
      await UserDetailsSharedPref.setUserName(googleUser.email);

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
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
