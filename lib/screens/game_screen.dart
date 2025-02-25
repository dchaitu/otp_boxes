import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/screens/settings_screen.dart';
import 'package:otp_boxes/screens/stats_dialog.dart';
import 'package:otp_boxes/themes/themes.dart';
// import 'package:otp_boxes/widgets/keyboard_listener_widget.dart';
import 'package:otp_boxes/widgets/keyboard_widget.dart';
import 'package:otp_boxes/widgets/word_grid_widget.dart';

void handleKeyPress(BuildContext context, LogicalKeyboardKey key, WidgetRef ref) {

  final currentWordLength = ref.watch(textInputProvider).currentWord.length;

  if (key == LogicalKeyboardKey.enter) {
    // if (currentWordLength < 5) {
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       title: const Text("Invalid Word"),
    //       content: const Text("Word must be exactly 5 characters long!"),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.of(context).pop(), // Close the dialog
    //           child: const Text("OK"),
    //         ),
    //       ],
    //     ),
    //   );
    //   return;
    // }
    ref.read(textInputProvider.notifier).enterChar(ref);
    print("Enter");
    final userWords = ref.watch(textInputProvider).userWords;
    print("userWords $userWords");


  } else if (key == LogicalKeyboardKey.backspace) {
    ref.read(textInputProvider.notifier).removeChar();
    print("Back");
  }
  else if (key.keyLabel.isNotEmpty && key.keyLabel.length == 1) {
    // Handle character input
    final char = key.keyLabel.toUpperCase();
    ref.read(textInputProvider.notifier).addChar(char);
    print("Physical Keyboard $char");
  }
}


class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    final bool isWonTextInput = ref.watch(textInputProvider).isWon;
    final int noOfChances = ref.watch(textInputProvider).noOfChances;
    final currentWordLength = ref.watch(textInputProvider).currentWord.length;

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
        body: KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    onKeyEvent: (KeyEvent event) {
    if (event is KeyDownEvent) {
    handleKeyPress(context,event.logicalKey,ref);
    // if(event.logicalKey == LogicalKeyboardKey.enter)
    //   { print("currentWordLength $currentWordLength");
    //     if (currentWordLength < 5) {
    //       showDialog(
    //         context: context,
    //         builder: (_) => AlertDialog(
    //           title: const Text("Invalid Word"),
    //           content: const Text("Word must be exactly 5 characters long!"),
    //           actions: [
    //             TextButton(
    //               onPressed: () => Navigator.of(context).pop(), // Close the dialog
    //               child: const Text("OK"),
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //   }
    }
    },child:Builder(
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
                  SizedBox(height: 10),
                  KeyboardWidget()
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
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
