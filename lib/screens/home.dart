import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mochileros/screens/huesped/mis_reservas_screen.dart';
import 'package:mochileros/screens/huesped/reservar_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  //cambiamos el nombre del estado para que sea más claro
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF6B5FB5),
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        title: const Text('Mochileros', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Center(
                child: Text(
                  'Menú Hostel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // cierra el Drawer
              },
            ),
            if (user == null) ...[
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sesion'),
                onTap: () {
                  //Aqui va el screen para iniciar sesion
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Crear Cuenta'),
                onTap: () {
                  //Aqui va el screen para crear una cuenta
                  Navigator.pop(context);
                },
              )
            ] else ...[
              ListTile(
                leading: const Icon(Icons.bed),
                title: const Text('Habitaciones'),
                onTap: () {
                  //conectamos este botón al flujo de reserva
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReservarScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark),
                title: const Text('Mis Reservas'),
                onTap: () {
                  //conectamos este botón a la pantalla de "Mis Reservas"
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MisReservasScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar Sesion'),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
      //envolvemos el body en un SingleChildScrollView para evitar que se desborde en pantallas pequeñas
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Bienvenido a Hostel Mochileros", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'A continuacion le mostramos una vista previa de nuestro Hostel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset('assets/images/VistaPrincipal.jpg', width: double.infinity, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 8),
              const Text(
                'Esta es la entrada principal de nuestro Hostel, rodeado de plantas naturales que acompañan bien con una hermosa iluminacion en las mañanas. Ademas, contamos con un pequeño estacionamiento alojado cerca de la entrada en caso de necesitar un lugar donde depositar sus vehiculos ',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Image.asset('assets/images/Secundaria.jpg', width: double.infinity, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 8),
              const Text(
                'Una vista previa a nuestra sala exterior. Donde premiamos la comunicacion y reflexion con los distintos viajantes acompañados de un hermoso paisaje rodeado de plantas naturales. Contamos con una piscina exterior extensa y un un mini bar a pocos metros.',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Container(
          color: Colors.teal,
          padding: const EdgeInsets.all(12),
          child: const Column(
            children: [
              Row(
                children: [
                  Text(
                    'Contact us : 7619 0342',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Spacer(),
                  Text(
                    'Mail : mochileros.uruguay@gmail.com',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '© 1999-2025 Hostelworld.com Limited. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}