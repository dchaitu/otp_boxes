import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/screens/settings_screen.dart';
import 'package:otp_boxes/screens/stats_dialog.dart';
import 'package:otp_boxes/themes/themes.dart';
import 'package:otp_boxes/widgets/keyboard_widget.dart';
import 'package:otp_boxes/widgets/word_grid_widget.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Wordle',
      theme: isDarkTheme ? darkTheme : lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wordle"),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.lightbulb)),
            Builder(builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => StatsDialog());
                },
                icon: Icon(Icons.bar_chart_outlined),
              );
            }),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.question_mark_rounded)),
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SettingsScreen()));
                    });
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              const Divider(thickness: 2, height: 1),
              const SizedBox(
                height: 10,
              ),
              const WordGridWidget(),
              const SizedBox(
                height: 10,
              ),
              KeyboardWidget()
            ],
          ),
        ),
        // backgroundColor: Colors.black,
      ),
    );
  }
}
