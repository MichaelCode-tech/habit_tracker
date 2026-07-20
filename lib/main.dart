import 'package:flutter/material.dart';
import 'package:habit_tracker/DB/DB.dart';
import 'package:habit_tracker/pages/homePage.dart';
import 'package:habit_tracker/theme/themeProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize DB
  await HabitDB.initialize();
  await HabitDB().saveFirstLaunchDate();

  // get theme setting
  bool isDarkMode = await HabitDB().getIsDarkMode();

  runApp(
    MultiProvider(
      providers: [
        // Habit DB provider
        ChangeNotifierProvider(create: (context) => HabitDB()),

        // Theme provider
        ChangeNotifierProvider(create: (context) => ThemeProvider(isDarkMode)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      home: const homePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
