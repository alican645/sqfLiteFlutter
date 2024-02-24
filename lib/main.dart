import 'package:flutter/material.dart';
import 'package:sqflite_kullanim/screens/studentListView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:StudentListView()
    );
  }
}


