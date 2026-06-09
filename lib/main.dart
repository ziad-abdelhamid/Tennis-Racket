import 'package:flutter/material.dart';
import 'screen.dart';
void main() => runApp(const TennisRacketApp());
class TennisRacketApp extends StatelessWidget {
  const TennisRacketApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const uiScreen(),
    );
  }
}