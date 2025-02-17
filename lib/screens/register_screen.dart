import 'package:flutter/material.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Create User')),

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
                  hintText: "Email",
                ),
                controller: emailController,
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
                child: ElevatedButton(onPressed: (){
                  ApiService().userSignup(
                      userController.text.toString(),
                      emailController.text.toString(),
                      passwordController.text.toString()).then((value) {
                    setState(() {
                      // login = value!;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    });
                  }).onError((error, stackTrace) {
                    print("Error:- ${error}");
                  });

                },
                    child: const Text("Register")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
