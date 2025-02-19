import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/get_word_from_words_provider.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/screens/settings_screen.dart';
import 'package:otp_boxes/screens/stats_dialog.dart';
import 'package:otp_boxes/themes/themes.dart';
import 'package:otp_boxes/widgets/keyboard_widget.dart';
import 'package:otp_boxes/widgets/word_grid_widget.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {

  @override
  void initState() {
    ref.read(wordsFromAPIProvider).getWord();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    final bool isWonTextInput = ref
        .watch(textInputProvider)
        .isWon;
    final int noOfChances = ref
        .watch(textInputProvider)
        .noOfChances;
    print("noOfChances $noOfChances");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wordle',
      theme: isDarkTheme ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wordle"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.lightbulb)),
            Builder(builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  showDialog(
                      context: context, builder: (_) => const StatsDialog());
                },
                icon: const Icon(Icons.bar_chart_outlined),
              );
            }),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.question_mark_rounded)),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsScreen()));
                    });
              },
            )
          ],
        ),
        body: Builder(
          builder: (BuildContext newContext) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (isWonTextInput) {
                showPrompt(newContext, "Splendid!");
                handleCaseCorrect(newContext);
              }
              if (noOfChances == 0) {
                print("Prompt should display");
                showPrompt(newContext, "CREPE");
              }
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


  void handleCaseCorrect(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      showDialog(context: context, builder: (context) => const StatsDialog());
    });
  }

  void showPrompt(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            Navigator.maybePop(context);
          });
          return AlertDialog(
            title: Text(message, textAlign: TextAlign.center),
          );
        });
  }
}
