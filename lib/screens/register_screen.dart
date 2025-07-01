import 'package:flutter/material.dart';
import 'package:otp_boxes/constants/colors.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
                decoration: InputDecoration(
                    hintText: "UserName",
                    hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    prefixIcon: Icon(Icons.person,
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
                controller: userController,
                style: Theme.of(context).textTheme.bodyMedium),
            TextField(
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color),
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).textTheme.bodyMedium?.color)),
                controller: emailController,
                style: Theme.of(context).textTheme.bodyMedium),
            TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                  prefixIcon: Icon(Icons.lock,
                      color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                obscureText: true,
                controller: passwordController,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    ApiService(token: '')
                        .userSignup(
                            userController.text.trim().toString(),
                            emailController.text.trim().toString(),
                            passwordController.text.trim().toString())
                        .then((value) {
                      setState(() {
                        // login = value!;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      });
                    }).onError((error, stackTrace) {
                      print("Error:- $error");
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(correctGreen)),
                  child: const Text("Register",
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
