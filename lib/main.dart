import 'package:flutter/material.dart';
import 'package:mochileros/services/persistencia/credentials.dart'; //asegúrate que esta ruta exista y sea correcta
import 'package:mochileros/screens/admin/admin_home_screen.dart';
import 'package:mochileros/screens/home.dart';
import 'package:mochileros/screens/huesped/reservar_screen.dart'; //importamos la pantalla de reservar para probarla
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl, // URL del proyecto 
    anonKey: supabaseAnonKey,  // clave pública anónima
  );
  runApp(const MyApp());
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
      
      //--- Para testear, elige con qué pantalla iniciar ---
      //descomenta la que quieras probar y comenta las otras

      // Opción 1: Iniciar en la pantalla principal
      //home: const Home(), 
      
      // Opción 2: Iniciar directamente en el panel de administrador.
      // home: const AdminHomeScreen(),

      // Opción 3: Iniciar en la pantalla para reservar
      home: const ReservarScreen(),
    );
  }
}