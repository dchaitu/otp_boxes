import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/screens/game_screen.dart';

class KeyboardListenerWidget extends ConsumerWidget {
  const KeyboardListenerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            handleKeyPress(context,event.logicalKey,ref);
          }
        },
        child: const GameScreen());
  }
}

void handleKeyPress(BuildContext context, LogicalKeyboardKey key, WidgetRef ref) {

  final currentWordLength = ref.watch(textInputProvider).currentWord.length;

  if (key == LogicalKeyboardKey.enter) {
    if (currentWordLength < 5) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Invalid Word"),
          content: const Text("Word must be exactly 5 characters long!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
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

