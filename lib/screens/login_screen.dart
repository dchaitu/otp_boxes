import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/screens/register_screen.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:otp_boxes/widgets/google_log_in_widget.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';
import '../constants/colors.dart';
import '../constants/utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus();
    });
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
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
                  decoration: InputDecoration(
                    hintText: "UserName",
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  controller: userController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter username" : null,
                  style: Theme.of(context).textTheme.bodyMedium),
              TextFormField(
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                      prefixIcon: Icon(Icons.lock,
                          color: Theme.of(context).textTheme.bodyMedium?.color),
                      suffixIcon: IconButton(
                          onPressed: () {
                            print(
                                "Show password is ${ref.read(showObscureTextProvider)}");
                            ref.read(showObscureTextProvider.notifier).state =
                                !ref.read(showObscureTextProvider);
                          },
                          icon: Icon(Icons.remove_red_eye,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color))),
                  obscureText: ref.watch(showObscureTextProvider),
                  controller: passwordController,
                  validator: (value) =>
                      value!.isEmpty ? "Enter password" : null,
                  style: Theme.of(context).textTheme.bodyMedium),
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

                        if (loginResponse != null &&
                            loginResponse["access"] != null) {
                          // Save token and username from login response
                          await UserDetailsSharedPref.setToken(
                              loginResponse['access']!);
                          await UserDetailsSharedPref.setUserName(username);

                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const KeyboardListenerWidget(),
                            ),
                            (route) => false,
                          );
                          return;
                        }

                        // If we get here, login failed
                        if (!mounted) return;
                        showErrorMessage(
                            'Invalid username or password', context, mounted);
                      } catch (e) {
                        if (!mounted) return;
                        showErrorMessage('An error occurred. Please try again.',
                            context, mounted);
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
              const GoogleLogInWidget(),
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
    if (!mounted) return;

    String? storedToken = UserDetailsSharedPref.getUserToken();

    if (storedToken != null && storedToken.isNotEmpty) {
      // Use a small delay to ensure the navigation happens after the current build phase
      await Future.delayed(Duration.zero);

      if (!mounted) return;

      // Use pushAndRemoveUntil to clear the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const KeyboardListenerWidget()),
        (route) => false,
      );
    }
  }
}
