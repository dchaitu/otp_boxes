import 'package:otp_boxes/constants/enum.dart';

class Tile {
  final String letter;
  TileType validate;
  bool shouldRotate;

  Tile({required this.letter, required this.validate, this.shouldRotate=false});

  Tile copyWith({bool? shouldRotate})
  {
    return Tile(letter: letter, validate: validate, shouldRotate: shouldRotate?? this.shouldRotate);
  }

  @override
  String toString()
  {
    return letter;
  }
}
