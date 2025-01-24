import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';
import 'package:otp_boxes/screens/game_screen.dart';

class StatsDialog extends ConsumerWidget {
  const StatsDialog({super.key});

  Widget scoreInField(String number, String field) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            field,
            style: const TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.clear),
              alignment: Alignment.topRight),
          const Expanded(
              child: Text(
            'Statistics',
            style: TextStyle(fontSize: 24, fontFamily: 'Georgia'),
          )),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                scoreInField('0', 'Played'),
                scoreInField('0', 'Win %'),
                scoreInField('0', 'Current\nStreak'),
                scoreInField('0', 'Max\nStreak')
              ],
            ),
          ),
          Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    // resetGameState
                    ref.read(textInputProvider.notifier).resetGameState(ref);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameScreen()),
                        (route) => false);
                  },
                  child: const Text('Replay')))
        ],
      ),
    );
  }
}



