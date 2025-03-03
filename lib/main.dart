import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/screens/game_screen.dart';
import 'package:otp_boxes/screens/login_screen.dart';
import 'package:otp_boxes/screens/settings_screen.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDetailsSharedPref.init();
  runApp(const ProviderScope(
      child: MainScreen(),
    ),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Set global navigator key
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/game': (context) => const GameScreen(),
        '/settings':(context) => const SettingsScreen()
      },
      home: const LoginScreen(),
    );
  }
}





