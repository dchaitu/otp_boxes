import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/screens/game_screen.dart';

class KeyboardListenerWidget extends ConsumerWidget {
  const KeyboardListenerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GameScreen();
  }
}


