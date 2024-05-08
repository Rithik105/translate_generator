import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translate_generator/providers/language_provider.dart';
import 'package:translate_generator/utils/app_colors.dart';

import 'ui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.accentColor,
              foregroundColor: Colors.white),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.accentColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
      ], child: const HomeScreen()),
    );
  }
}
