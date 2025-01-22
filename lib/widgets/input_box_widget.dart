import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/themes/themes.dart';

class InputBoxWidget extends ConsumerWidget {
  final TextEditingController controller;
  final TileType validate;

  const InputBoxWidget(
      {super.key,
      required this.controller,
      this.validate = TileType.notAnswered});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);

    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getBackgroundColor(validate),
        border: Border.all(width: 2, color: Colors.grey),
      ),
      height: 64,
      width: 64,
      child: TextField(
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: isDarkTheme ? darkTheme.appBarTheme.titleTextStyle: lightTheme.appBarTheme.titleTextStyle,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        controller: controller,
      ),
    );
  }
}
