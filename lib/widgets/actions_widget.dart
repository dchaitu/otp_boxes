import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';
import '../screens/stats_dialog.dart';

List<Widget> actionsWidget() {
  return [
    IconButton(onPressed: () {}, icon: const Icon(Icons.lightbulb)),
    Builder(builder: (BuildContext context) {
      return IconButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => const StatsDialog());
        },
        icon: const Icon(Icons.bar_chart_outlined),
      );
    }),
    IconButton(onPressed: () {}, icon: const Icon(Icons.question_mark_rounded)),
    Builder(
      builder: (BuildContext context) {
        return IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            });
      },
    )
  ];
}
