import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/game_logic.dart';
import 'package:otp_boxes/screens/register_screen.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';

import '../constants/colors.dart';

class LoginScreen extends ConsumerStatefulWidget {


  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var token;
  @override
  void initState() {
    super.initState();
    token = UserDetailsSharedPref.getUserToken()?? "";
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Login Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          // child: KeyboardListener(
          //   focusNode: FocusNode(),
          //   onKeyEvent: (KeyEvent event) {
          //     if (event.logicalKey == LogicalKeyboardKey.enter) {
          //       if(_formKey.currentState!.validate())
          //         {
          //           loginUser(userController,passwordController,context);
          //         }
          //     }
          //   },
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "UserName",
                      prefixIcon: Icon(Icons.person)
                    ),
                    controller: userController,
                    validator: (value)=> value!.isEmpty? "Enter username":null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock)
                    ),
                    obscureText: true,
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
                          String username = userController.text.toString();
                          String password = passwordController.text.toString();
                          var tok = await getJwtToken(username,  password);
                          print("Inside login screen $tok");


                          if (token.isNotEmpty && token==tok) {
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

                            Map<String, dynamic>? tokenResponse = await userLoginWithToken(username, password, context, ref);
                            print("tokenResponse in login screen  $tokenResponse");
                            await UserDetailsSharedPref.setToken(tok.toString());
                            print("New token is ${UserDetailsSharedPref.getUserToken()}");
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
                          },
                        child: const Text("Login",style: TextStyle(color: Colors.white),),
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











