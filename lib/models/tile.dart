import 'package:otp_boxes/constants/enum.dart';

class Tile {
  final String letter;
  TileType validate;

  Tile({required this.letter, required this.validate});

  @override
  String toString()
  {
    return letter;
  }
}
