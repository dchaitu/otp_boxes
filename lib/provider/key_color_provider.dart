import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/enum.dart';

class KeyColorNotifier extends StateNotifier<Map<String, TileType>>{
  KeyColorNotifier():super({});

  void updateKeyColor(String key, TileType validate)
  {
    state = {...state, key:validate};
  }
  void resetColors()
  {
    state = {};
  }

}

final keyColorProvider = StateNotifierProvider<KeyColorNotifier, Map<String, TileType>>((ref)=> KeyColorNotifier());
