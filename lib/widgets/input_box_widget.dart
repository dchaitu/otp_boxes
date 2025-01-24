import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_boxes/constants/key_colors.dart';
import 'package:otp_boxes/constants/enum.dart';
import 'package:otp_boxes/constants/uppercase_input_formatter.dart';

class InputBoxWidget extends StatelessWidget {
  final TextEditingController controller;
  final TileType validate;
  final FocusNode focusNode;

  const InputBoxWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.validate = TileType.notAnswered,
  });

  @override
  Widget build(BuildContext context) {
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
        focusNode: focusNode,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        style: Theme.of(context).appBarTheme.titleTextStyle,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          UpperCaseTextInputFormatter(),
        ],
        controller: controller,
      ),
    );
  }
}
