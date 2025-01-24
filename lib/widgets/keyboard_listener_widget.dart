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
            handleKeyPress(event.logicalKey,ref);
          }
        },
        child: const GameScreen());
  }
}

void handleKeyPress(LogicalKeyboardKey key, WidgetRef ref) {

  if (key == LogicalKeyboardKey.enter) {
    ref.read(textInputProvider.notifier).enterChar(ref);
    print("Enter");
  } else if (key == LogicalKeyboardKey.backspace) {
    ref.read(textInputProvider.notifier).removeChar();
    print("Back");
  }
  else if (key.keyLabel.isNotEmpty && key.keyLabel.length == 1) {
    // Handle character input
    final char = key.keyLabel.toUpperCase();
    ref.read(textInputProvider.notifier).addChar(char);
    print(char);
  }
}