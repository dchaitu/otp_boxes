import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/provider/key_color_provider.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/themes/themes.dart';

class KeyboardWidget extends ConsumerWidget {
  final FocusNode _focusNode;

  KeyboardWidget({Key? key})
      : _focusNode = FocusNode(),
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardListener(
        focusNode: _focusNode,
    autofocus: true,
    onKeyEvent: (KeyEvent event) {
          if(event is KeyDownEvent)
            {
              final logicalKey = event.logicalKey;
              if (logicalKey == LogicalKeyboardKey.enter) {
                ref.read(textInputProvider.notifier).enterChar(ref);
                _focusNode.nextFocus();
              } else if (logicalKey == LogicalKeyboardKey.backspace) {
                ref.read(textInputProvider.notifier).removeChar();
              } else if (logicalKey.keyLabel.length == 1 &&
                  RegExp(r'[A-Za-z]').hasMatch(logicalKey.keyLabel)) {
                ref.read(textInputProvider.notifier).addChar(logicalKey.keyLabel.toUpperCase());
                _focusNode.nextFocus();
              }
            }
    },
    child: allLetters(ref));
  }
}

Widget allLetters(WidgetRef ref) {
  const List<String> allRows = [
    'Q W E R T Y U I O P',
    'A S D F G H J K L',
    'Enter Z X C V B N M Back',
  ];

  List<Row> keyboard = [];
  for (String row in allRows) {
    List<Widget> eachRow = [];

    for (var key in row.split(' ')) {
      if (key.contains('Enter')) {
        eachRow.add(keyBoardButton(
            key, () => ref.read(textInputProvider.notifier).enterChar(ref), ref));
      } else if (key.contains('Back')) {
        eachRow.add(keyBoardButton(
            key, () => ref.read(textInputProvider.notifier).removeChar(), ref));
      } else {
        eachRow.add(keyBoardButton(
            key, () => ref.read(textInputProvider.notifier).addChar(key), ref));
      }
    }

    keyboard.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: eachRow,
    ));
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: keyboard,
  );
}

Widget keyWidget(
    String letter, VoidCallback onTap, Widget childWidget, WidgetRef ref) {
  final keyValidationStatus = ref.watch(keyColorProvider);

  final tileType = keyValidationStatus[letter] ?? TileType.notAnswered;
  final buttonColor = getColorFromTile[tileType];
  const double marginSpace = 4.0;
  const double circularRadius = 8;
  print("buttonColor $buttonColor, tileType $tileType");


  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circularRadius),
        color: buttonColor,
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(marginSpace),
      width: 40,
      height: 60,
      child: Center(child: childWidget),
    ),
  );
}

Widget keyBoardButton(String letter, VoidCallback onTap, WidgetRef ref) {
  final isDarkTheme = ref.watch(themeProvider);
  final Color? keyColor =  isDarkTheme ? darkTheme.appBarTheme.titleTextStyle?.color: lightTheme.appBarTheme.titleTextStyle?.color;

  if (letter == 'Enter') {
    return SizedBox(
      width: 80,
      child: keyWidget(
          letter,
          onTap,
          Icon(Icons.keyboard_return, size: 24, color: keyColor),
          ref),
    );
  } else if (letter == 'Back') {
    return SizedBox(
      width: 80,
      child: keyWidget(
          letter,
          onTap,
          Icon(Icons.backspace_outlined, size: 24, color: keyColor),
          ref),
    );
  } else {
    return keyWidget(
        letter, onTap,
        Text(letter,
          style: TextStyle(color: keyColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ref);
  }
}