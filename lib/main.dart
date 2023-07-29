import 'package:flutter/material.dart';
import 'package:personal_assistant/pallete.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:personal_assistant/screens/homepage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Your Assistant',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        )),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

