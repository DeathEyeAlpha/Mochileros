// lib/main.dart
import 'package:flutter/material.dart';
// Usa el nombre de tu paquete (debería ser 'mochileros' según el error)
import 'package:mochileros/screens/admin/admin_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Mochileros',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AdminHomeScreen(),
    );
  }
}