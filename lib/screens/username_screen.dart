import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/colors.dart';
import 'package:otp_boxes/constants/variables.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  final String email;
  final String googleId;

  const UsernameScreen({
    super.key,
    required this.email,
    required this.googleId,
  });

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }


  Future<void> _submitUsername() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    print("Google ID before submitUsername: ${widget.googleId}");

    try {
      final response = await http.post(
        Uri.parse(googleLoginUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "email": widget.email,
          "googleId": widget.googleId
        }),
      );
      print("Username screen response: ${response.body}, ${response.statusCode}");

      if (response.statusCode == 201) {
        // Save username locally
        await UserDetailsSharedPref.setUserName(username);

        // Get JWT token for the user
        final tokenResponse = await http.post(
          Uri.parse(authApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': widget.googleId, // Use googleId as password for Google users
          }),
        );

        if (tokenResponse.statusCode == 200) {
          final tokenData = jsonDecode(tokenResponse.body);
          await UserDetailsSharedPref.setToken(tokenData['access']);

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const KeyboardListenerWidget()),
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to obtain token: ${tokenResponse.body}';
            _isLoading = false;
          });
        }
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorData['error'] ?? 'Failed to set username';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error in submitUsername function: ${e.toString()}';
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Username'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a username to continue',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 3) {
                    return 'Username must be at least 3 characters';
                  }
                  return null;
                },
              ),
              if (_errorMessage != null) ...{
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              },
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitUsername,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: correctGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
