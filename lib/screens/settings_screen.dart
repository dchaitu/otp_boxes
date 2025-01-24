import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: Icon(Icons.clear))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SwitchListTile(title: Text("Hard Mode",style: Theme.of(context).textTheme.bodyMedium,), subtitle: Text('Any revealed hints must be used in subsequent guesses',style: Theme.of(context).textTheme.bodyMedium), value: true, onChanged: (bool value) {  },),
            Divider(thickness: 1.2,),
            SwitchListTile(
                title: Text(
                  "Dark Theme",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: isDarkTheme,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).state = value;
                })
          ],
        ),
      ),
    );
  }
}
