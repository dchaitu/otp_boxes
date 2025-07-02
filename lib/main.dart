import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/screens/game_screen.dart';
import 'package:otp_boxes/screens/login_screen.dart';
import 'package:otp_boxes/screens/settings_screen.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/themes/themes.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    UserDetailsSharedPref.init(),
  ]);
  try{
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  }
  catch(e){
    print("Error activating Firebase App Check: $e");
  }
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  
  runApp(const ProviderScope(
    child: MainScreen(),
  ));
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);


    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: isDarkTheme ? darkTheme : lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wordle',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/game': (context) => const GameScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}





