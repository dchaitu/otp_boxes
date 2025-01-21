import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_boxes/constants/colors.dart';
import 'package:otp_boxes/enum.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final TileValidate validation;

  const InputBox(
      {super.key,
      required this.controller,
      this.validation = TileValidate.notAnswered});

  Color getBackgroundColor() {
    switch (validation) {
      case TileValidate.correctPosition:
        return correctGreen;
      case TileValidate.present:
        return containsYellow;
      case TileValidate.notPresent:
        return notPresentGrey;
      default:
        return Colors.black12;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: getBackgroundColor(),
        border: Border.all(width: 2, color: Colors.grey),
      ),
      height: 64,
      width: 64,
      child: TextField(
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.white),
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
