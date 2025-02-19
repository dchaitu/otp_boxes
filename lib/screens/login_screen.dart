import 'package:flutter/material.dart';
import 'package:otp_boxes/models/login.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/screens/register_screen.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';

class LoginScreen extends StatefulWidget {


  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    Login login = Login();



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
                    onPressed: () {
                      ApiService()
                          .userLogin(userController.text.toString(),
                              passwordController.text.toString())
                          .then((value) {
                        setState(() {
                          login = value!;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const KeyboardListenerWidget()));
                        });
                      }).onError((error, stackTrace) {
                        print("Error:- ${error}");
                      });
                    },
                    child: const Text("Login")),
              ),
              TextButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },

                  child: Text("Don't have account create here"))
            ],
          ),
        ),
      ),
    );
  }


}









