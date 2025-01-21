
import 'package:flutter/material.dart';
import 'package:otp_boxes/constants/colors.dart';
import 'package:otp_boxes/enum.dart';

String letters = "QWERTYUIOPASDFGHJKLZXCVBNM";


Map<String,TileValidate> keyColorsMap = {
for(var letter in letters.split(''))
  letter: TileValidate.notAnswered
};

Map<TileValidate,Color> validationColors = {
  TileValidate.notAnswered: notAnsweredTrans,
  TileValidate.correctPosition: correctGreen,
  TileValidate.present: containsYellow,
  TileValidate.notPresent: notPresentGrey
};
