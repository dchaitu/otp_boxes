import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/word_grid.dart';
import 'package:otp_boxes/word_key.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wordle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            "Wordle",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
            centerTitle:true
        ),
        body: const Center(
            child: Column(
          children: [
            Expanded(flex: 5, child: WordGrid()),
            Expanded(flex: 2, child: KeyboardWidget())
          ],
        )),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
