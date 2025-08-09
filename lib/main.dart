import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/Notifiers/thememode_notifier.dart';
import 'package:notebook/hive/hive_box_const.dart';
import 'package:notebook/modules/helpers.dart';
import 'package:notebook/screens/home_screen.dart';

Future main() async {
  // It is used so that void main function can
  // be intiated after successfully intialization of data
  WidgetsFlutterBinding.ensureInitialized();

  // To intialise the hive database
  await Hive.initFlutter();

  // To open the user hive box
  await Hive.openBox(userHiveBox);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    var pageWidth = UIHelpers.pageWidth(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(31, 116, 47, 95),
        ),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      themeMode: themeMode,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: SafeArea(
        child: Stack(
          children: [
            Scaffold(body: const HomeScreen()),
            Positioned(
              left: pageWidth * 0.8,
              child: IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: themeModeNotifier.toggle,
                tooltip: 'Toggle Theme',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
