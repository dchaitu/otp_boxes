import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/game_logic.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/themes/themes.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';
import 'package:otp_boxes/widgets/keyboard_widget.dart';
import 'package:otp_boxes/widgets/word_grid_widget.dart';

import '../widgets/actions_widget.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final token = UserDetailsSharedPref.getUserToken();
      if(token!.isNotEmpty)
      {
        ref.read(wordsFromAPIProvider.notifier).state = ApiService(token: token);
        print("Now token is $token");
        ref.read(wordsFromAPIProvider).getWord();

      }
      else {
        print("Error: No token found!");
      }

    });

  }


  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wordle',
      theme: isDarkTheme ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wordle"),
          centerTitle: true,
          actions: actionsWidget(),
        ),
        body: Builder(
          builder: (BuildContext newContext) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              gameConditions(ref, newContext);
            });
            return const Center(
              child: Column(
                children: [
                  Divider(thickness: 2, height: 1),
                  SizedBox(height: 10),
                  WordGridWidget(),
                  Spacer(),
                  KeyboardWidget()
                ],
              ),
            );
          },
        ),
      ),
    );
  }



}
