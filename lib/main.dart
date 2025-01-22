import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/screens/game_screen.dart';


void main() {
  runApp(const ProviderScope(child: GameScreen()));
}


