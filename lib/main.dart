import 'package:flutter/material.dart';
import 'package:qrcode_absensi/first_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blue)),
      home: const FirstScreen(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}
