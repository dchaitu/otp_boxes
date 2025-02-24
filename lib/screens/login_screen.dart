import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/screens/register_screen.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {


  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Login Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                    hintText: "User Name"),
                controller: userController,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
                obscureText: true,
                controller: passwordController,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      // TODO: Business logic need to be moved
                      String username = userController.text.toString();
                      String password = passwordController.text.toString();
                      print("Inside login screen");
                      Map<String, dynamic>? tokenResponse =
                      await ApiService(token: '').getToken(username, password);

                    if(tokenResponse!=null && tokenResponse["access"]!=null) {
                      print("User saved");
                      Future.delayed(Duration.zero, () {
                        ref.read(tokenProvider.notifier).state = tokenResponse["access"].toString();
                        ref.read(usernameProvider.notifier).state = username;
                      });
                      var resp = await ref.read(wordsFromAPIProvider)
                          .userLogin(username, password);
                      print("resp is ${resp}");
                      if (tokenResponse["access"].isNotEmpty) {

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
                    }
                    },
                    child: const Text("Login"),
                ),
              ),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },

                  child: const Text("Don't have account create here"))
            ],
          ),
        ),
      ),
    );
  }


}











