import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/screens/register_screen.dart';
import 'package:otp_boxes/screens/username_screen.dart';
import 'package:otp_boxes/services/auth_service.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';
import '../constants/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  var token;
  @override
  void initState() {
    super.initState();
    token = UserDetailsSharedPref.getUserToken() ?? "";
    checkLoginStatus();
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Helper method to show error message safely
  void _showErrorMessage(String message) {
    if (!mounted) return;

    // Ensure we have a Scaffold in the widget tree
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "UserName", prefixIcon: Icon(Icons.person)),
                controller: userController,
                validator: (value) => value!.isEmpty ? "Enter username" : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          print(
                              "Show password is ${ref.read(showObscureTextProvider)}");
                          ref.read(showObscureTextProvider.notifier).state =
                              !ref.read(showObscureTextProvider);
                        },
                        icon: const Icon(Icons.remove_red_eye))),
                obscureText: ref.watch(showObscureTextProvider),
                controller: passwordController,
                validator: (value) => value!.isEmpty ? "Enter password" : null,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(correctGreen)),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        final username = userController.text.trim();
                        final password = passwordController.text.trim();

                        // First validate credentials using userLogin
                        final loginResponse = await ref
                            .read(wordsFromAPIProvider)
                            .userLogin(username, password);
                        print("Login Response: $loginResponse");
                        
                        if (loginResponse != null && loginResponse["access"] != null) {
                          // Save token and username from login response
                          await UserDetailsSharedPref.setToken(loginResponse['access']!);
                          await UserDetailsSharedPref.setUserName(username);

                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KeyboardListenerWidget(),
                            ),
                          );
                          return;
                        }

                        // If we get here, login failed
                        if (!mounted) return;
                        _showErrorMessage('Invalid username or password');
                      } catch (e) {
                        if (!mounted) return;
                        _showErrorMessage(
                            'An error occurred. Please try again.');
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login",
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
                  onPressed: () async {
                    try {
                      final authService = AuthService();
                      final result = await authService.signInWithGoogle();
                      // print("result is ${result.toString()}");

                      // print("accessToken is ${result?['credential'].accessToken}");
                      if (result == null || result['userCredential'] == null) {
                        if (!mounted) return;
                        _showErrorMessage('Failed to sign in with Google');
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
                      _showErrorMessage('Error: ${e.toString()}');
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
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Create here"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> checkLoginStatus() async {
    String? storedToken = UserDetailsSharedPref.getUserToken();

    if (storedToken != null && storedToken.isNotEmpty) {
      // Verify token validity (optional: make an API call to check)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KeyboardListenerWidget()),
      );
    }
  }
}
