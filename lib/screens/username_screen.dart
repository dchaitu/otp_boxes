import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/colors.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  final String email;
  final String googleId;

  const UsernameScreen({
    Key? key,
    required this.email,
    required this.googleId,
  }) : super(key: key);

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

  Future<void> _checkAndSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final username = _usernameController.text.trim();
      
      // Get the API service instance
      final apiService = ref.read(wordsFromAPIProvider);
      
      // Check if username exists
      final usernameExists = await apiService.checkUsernameExists(username);
      
      if (usernameExists) {
        setState(() {
          _errorMessage = 'Username already taken. Please choose another one.';
          _isLoading = false;
        });
        return;
      }

      // If username doesn't exist, create a new user with Google signup
      final signupResult = await apiService.userSignup(
        username,
        widget.email,
        widget.googleId, // Using Google ID as password
        isGoogleSignup: true,
      );

      if (signupResult != null && signupResult['message']?.contains('created') == true) {
        if (!mounted) return;
        
        // Get token for the newly created user
        final tokenResponse = await apiService.getToken(username, widget.googleId);
        
        if (tokenResponse != null && tokenResponse['access'] != null) {
          // Save token and navigate to home
          await UserDetailsSharedPref.setToken(tokenResponse['access']);
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
      }
      
      // If we get here, something went wrong
      setState(() {
        _errorMessage = 'Failed to create account. Please try again.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
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
                  onPressed: _isLoading ? null : _checkAndSubmit,
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
