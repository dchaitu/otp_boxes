import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/enum.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';

class KeyboardWidget extends ConsumerWidget {
  const KeyboardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return allLetters(ref);
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
            key, () => ref.read(textInputProvider.notifier).enterChar(), ref));
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
  final keyValidationStatus = ref.watch(textInputProvider).keyColors;
  final validation = keyValidationStatus[letter] ?? TileValidate.notAnswered;
  final buttonColor = validationColors[validation];
  const double marginSpace = 4.0;
  const double circularRadius = 8;
  print("buttonColor $buttonColor, validation $validation");

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
  if (letter == 'Enter') {
    return SizedBox(
      width: 80,
      child: keyWidget(
          letter,
          onTap,
          const Icon(
            Icons.keyboard_return,
            size: 24,
            color: Colors.white,
          ),
          ref),
    );
  } else if (letter == 'Back') {
    return SizedBox(
      width: 80,
      child: keyWidget(
          letter,
          onTap,
          const Icon(Icons.backspace_outlined, size: 24, color: Colors.white),
          ref),
    );
  } else {
    return keyWidget(
        letter,
        onTap,
        Text(
          letter,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        ref);
  }
}