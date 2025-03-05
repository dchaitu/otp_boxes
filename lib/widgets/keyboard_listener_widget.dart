import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/screens/game_screen.dart';

class KeyboardListenerWidget extends ConsumerStatefulWidget {
  const KeyboardListenerWidget({super.key});


  @override
  _KeyboardListenerWidgetState createState() => _KeyboardListenerWidgetState();
}
class _KeyboardListenerWidgetState extends ConsumerState<KeyboardListenerWidget>{
  var _focusNode; // Persistent FocusNode

  @override
  void initState() {

    super.initState();
    Future.delayed(Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  // @override
  // void dispose() {
  //   _focusNode.dispose(); // Dispose to prevent memory leaks
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    _focusNode = ref.read(focusNodeProvider);
    return KeyboardListener(
        // autofocus: true,
        focusNode: _focusNode,
        onKeyEvent: (KeyEvent event) {
          print("keyboard key is ${event.logicalKey.keyLabel}");
          if (event is KeyDownEvent) {
            handleKeyPress(context,event.logicalKey,ref);
          }
        },
        child: const GameScreen());
  }
}

void handleKeyPress(BuildContext context, LogicalKeyboardKey key, WidgetRef ref) {

  final textInputNotifier = ref.read(textInputProvider.notifier);
  final currentWordLength = ref.read(textInputProvider).currentWord.length;


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
    final userWords = ref.watch(textInputProvider).userWords;
    print("userWords $userWords");
    ref.read(textInputProvider.notifier).enterChar(ref);
    print("Enter");


  } else if (key == LogicalKeyboardKey.backspace) {
    ref.read(textInputProvider.notifier).removeChar();
    print("Back");
  }
  else if (key.keyLabel.isNotEmpty && key.keyLabel.length == 1 && RegExp(r'^[A-Z]$').hasMatch(key.keyLabel)) {
    // Handle character input
    final char = key.keyLabel.toUpperCase();
    textInputNotifier.addChar(char);
    print("Physical Keyboard $char");
  }
}

