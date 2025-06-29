import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/constants/colors.dart';
import 'package:otp_boxes/provider/validation_providers.dart';
import 'package:otp_boxes/provider/text_input_provider.dart';

class StatsDialog extends ConsumerWidget {
  const StatsDialog({super.key});

  Widget scoreInField(String number, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            field,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      content: SizedBox(
        width: MediaQuery.of(context).size.width*0.70,
        height: MediaQuery.of(context).size.height*0.70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(fontSize: 24, fontFamily: 'Georgia'),
                  ),
              IconButton(
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.maybePop(context);
                    });
                  },
                  icon: const Icon(Icons.clear),
                  alignment: Alignment.topRight),

            ]),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  var focusNode = ref.read(focusNodeProvider);
                  ref.read(textInputProvider.notifier).resetGameState(ref,focusNode);
                  Navigator.popAndPushNamed(
                      context, '/game');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(correctGreen),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),),
                child: Text(
                  'Replay',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



