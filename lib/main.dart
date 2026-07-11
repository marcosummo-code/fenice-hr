import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TimbratureApp());
}

class TimbratureApp extends StatelessWidget {
  const TimbratureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timbrature Presenze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
