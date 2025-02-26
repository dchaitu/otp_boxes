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

  const KeyboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return allLetters(ref,context);
  }
}

Widget allLetters(WidgetRef ref, BuildContext context) {
  const List<String> allRows = [
    'Q W E R T Y U I O P',
    'A S D F G H J K L',
    'Enter Z X C V B N M Back',
  ];
  final width = MediaQuery.of(context).size.width;


  List<Widget> keyboard = [];
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
        eachRow.add(Container(
          child: keyBoardButton(
              key, () => ref.read(textInputProvider.notifier).addChar(key), ref),
        ));
      }
    }

    keyboard.add(Expanded(
      child: Row(
        spacing:0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: eachRow,
      ),
    ));
  }

  return SizedBox(
    width: width,
    height: 150,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: keyboard,
    ),
  );
}

Widget keyWidget(
    String letter, VoidCallback onTap, Widget childWidget, WidgetRef ref) {
  final keyValidationStatus = ref.watch(keyColorProvider);

  final tileType = keyValidationStatus[letter] ?? TileType.notAnswered;
  final buttonColor = getColorFromTile[tileType];
  int totalKeys = 10;  // Default key count for normal rows
  if (letter == 'Enter' || letter == 'Back') {
    totalKeys = 8;  // Adjust for rows with special keys
  }

  double marginSpace = totalKeys > 8 ? 0.5 : 3.0;
  const double circularRadius = 8;
  // print("buttonColor $buttonColor, tileType $tileType");


  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circularRadius),
        color: buttonColor,
      ),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.all(marginSpace),
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
      // width: 80,
      child: keyWidget(
          letter,
          onTap,
          Icon(Icons.keyboard_return, size: 24, color: keyColor),
          ref),
    );
  } else if (letter == 'Back') {
    return SizedBox(
      // width: 80,
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