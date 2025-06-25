import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_boxes/game_logic.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                  validator: (value) =>
                      value!.isEmpty ? "Enter username" : null,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(onPressed: () {
                          print("Show password is ${ref.read(showObscureTextProvider)}");
                          ref.read(showObscureTextProvider.notifier).state =
                          !ref.read(showObscureTextProvider);
                      },
                          icon: const Icon(Icons.remove_red_eye))

                    ),
                    obscureText: ref.watch(showObscureTextProvider),
                    controller: passwordController,
                    validator: (value)=> value!.isEmpty? "Enter password":null,
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child:  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style:ButtonStyle(backgroundColor:WidgetStateProperty.all(correctGreen)),
                        onPressed: () async {
                          String username = userController.text.trim().toString();
                          String password = passwordController.text.trim().toString();
                          var newTok = await getJwtToken(username,  password);
                          Map<String, dynamic>? tokenResponse =
                          await userLoginWithToken(username, password, context, ref);
                          print("Inside login screen $newTok");
                          print("tokenResponse in login screen  $tokenResponse");


                          if (tokenResponse != null && tokenResponse["access"] != null) {
                            String newToken = tokenResponse["access"];
                            await UserDetailsSharedPref.setToken(newToken);
                            await UserDetailsSharedPref.setUserName(username);

                            Future.delayed(Duration.zero, (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const KeyboardListenerWidget(),
                                ),
                              );
                            });
                          }
                          else{


                            await Future.delayed(Duration(milliseconds: 100)); // optional but helps in some cases

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));
                          }
                          },
                        child: const Text("Login",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
                      onPressed: () async {
                        try {
                          final authService = AuthService();
                          final userCredential = await authService.signInWithGoogle();
                          
                          if (userCredential?.user != null) {
                            // Navigate to username screen after successful Google sign in
                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsernameScreen(
                                  email: userCredential!.user!.email ?? '',
                                  googleId: userCredential.user!.uid,
                                ),
                              ),
                            );
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to sign in with Google')),
                            );
                          }
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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


                  TextButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen())
                    );
                  },
                      child: const Text("Don't have account? Create here"))
                ],
              ),
            ),
          ),
        ),
      // ),
    );
  }

  Future<void> loginUser(TextEditingController userController,
      TextEditingController passwordController, BuildContext context) async {
    {
      String username = userController.text.toString();
      String password = passwordController.text.toString();
      print("Inside login screen");
      Map<String, dynamic>? tokenResponse =
          await userLoginWithToken(username, password, context, ref);
      if (tokenResponse?["access"].isNotEmpty) {
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KeyboardListenerWidget(),
            ),
          );
        });
      }
    }
  }

  Future<void> checkLoginStatus() async {
    String? storedToken = await UserDetailsSharedPref.getUserToken();

    if (storedToken != null && storedToken.isNotEmpty) {
      // Verify token validity (optional: make an API call to check)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const KeyboardListenerWidget()),
      );
    }
  }
}
