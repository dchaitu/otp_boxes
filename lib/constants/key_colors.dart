
import 'package:flutter/material.dart';
import 'package:otp_boxes/constants/colors.dart';
import 'package:otp_boxes/constants/enum.dart';

String letters = "QWERTYUIOPASDFGHJKLZXCVBNM";


Map<String,TileType> keyColorsMap = {
for(var letter in letters.split(''))
  letter: TileType.notAnswered
};

Map<TileType,Color> getColorFromTile = {
  TileType.notAnswered: notAnsweredTrans,
  TileType.correctPosition: correctGreen,
  TileType.present: containsYellow,
  TileType.notPresent: notPresentGrey
};


Color getBackgroundColor(tileType) {
  switch (tileType) {
    case TileType.correctPosition:
      return correctGreen;
    case TileType.present:
      return containsYellow;
    case TileType.notPresent:
      return notPresentGrey;
    default:
      return Colors.black12;
  }
}