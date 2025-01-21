import 'package:otp_boxes/enum.dart';

class Tile {
  final String letter;
  TileValidate validate;

  Tile({required this.letter, required this.validate});

  @override
  String toString()
  {
    return letter;
  }
}
