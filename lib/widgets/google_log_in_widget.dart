import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_boxes/screens/username_screen.dart';
import 'package:otp_boxes/services/auth_service.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';

import '../constants/utils.dart';

class GoogleLogInWidget extends StatefulWidget {
  const GoogleLogInWidget({super.key});

  @override
  State<GoogleLogInWidget> createState() => _GoogleLogInWidgetState();
}

class _GoogleLogInWidgetState extends State<GoogleLogInWidget> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
        onPressed: () async {
          try {
            final authService = AuthService();
            final result = await authService.signInWithGoogle();
            print("Google Log in result is $result");

            if (result == null || result['userCredential'] == null) {
              if (!mounted) return;
              showErrorMessage('Failed to sign in with Google', context, mounted);
              return;
            }
            final username = result['username'];
            final email = result['email'];
            final googleId = result['googleId'];
            if(!mounted) return;
            if(username != null){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const KeyboardListenerWidget(),
                ),
              );
            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UsernameScreen(
                      email: email,
                      googleId: googleId
                  ),
                ),
              );

            }
          } catch (e) {
            if (!mounted) return;
            showErrorMessage('Error: ${e.toString()}', context, mounted);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        label: const Text(
          'Sign In with Google',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
