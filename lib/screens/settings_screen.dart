import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_boxes/provider/theme_provider.dart';
import 'package:otp_boxes/utils/user_details_shared_pref.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  var username;
  @override
  void initState()  {
    username = UserDetailsSharedPref.getUserName()??"Guest";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final isDarkTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const Icon(Icons.clear))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading:Icon(Icons.person_2_rounded,
              color: Theme.of(context).colorScheme.primary, ),
              title: Text(username,
                style: Theme.of(context).textTheme.bodyMedium,
              ),),
            SwitchListTile(
              title: Text(
                "Hard Mode",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                  'Any revealed hints must be used in subsequent guesses',
                  style: Theme.of(context).textTheme.bodyMedium),
              value: true,
              onChanged: (bool value) {},
            ),
            const Divider(thickness: 1.2),
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
