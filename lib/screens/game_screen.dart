import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/screens/settings_screen.dart';
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
      theme: isDarkTheme ?  darkTheme: lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Wordle"),
          centerTitle: true,
          actions: [
            Builder(

              builder: (BuildContext context) {
                return IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SettingsScreen())
                      );

                    });
              },

            )
          ],
        ),
        body: const Center(
          child: Column(
            children: [
              Divider(thickness: 2, height: 1),
              SizedBox(height: 10,),
              WordGridWidget(),
              SizedBox(height: 10,),
              KeyboardWidget()
            ],
          ),
        ),
        // backgroundColor: Colors.black,
      ),
    );
  }
}
