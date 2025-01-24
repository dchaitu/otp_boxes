import 'package:flutter/material.dart';
import 'package:otp_boxes/screens/game_screen.dart';

class StatsDialog extends StatelessWidget {
  const StatsDialog({super.key});

  Widget scoreInField(String number, String field) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            field,
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.clear),
              alignment: Alignment.topRight),
          Expanded(
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
          Expanded(child: ElevatedButton(onPressed: (){
            Navigator.pushAndRemoveUntil(context, 
                MaterialPageRoute(builder: (context) => GameScreen()), (route)=> false);
          }, child: Text('Replay')))
        ],
      ),
    );
  }
}
