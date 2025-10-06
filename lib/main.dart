
import 'package:flutter/material.dart';
import 'credentials.dart';
import 'package:mochileros/screens/admin/admin_home_screen.dart';
import 'package:mochileros/screens/admin/detalle_habitacion_screen.dart';
import 'package:mochileros/screens/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl, // URL del proyecto 
    anonKey: supabaseAnonKey,  // clave pública anónima
  );
  runApp(MyApp());
}
final supabase = Supabase.instance.client;

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
      home: Home(),
    );
  }
}