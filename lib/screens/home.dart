import 'package:flutter/material.dart';
import 'package:mochileros/main.dart';
import 'package:mochileros/screens/admin/admin_home_screen.dart';
import 'package:mochileros/screens/huesped/login.dart';
import 'package:mochileros/screens/huesped/registro.dart';
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
  late final Stream<AuthState> _authSubscription;
  bool logueado = false;
  bool admin = false;
  @override
  void  initState() {
    super.initState();

    // 🧠 Escucha cualquier cambio de sesión
    _authSubscription = supabase.auth.onAuthStateChange;
    _authSubscription.listen((data) async {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn) {
        debugPrint('Usuario ha iniciado sesión: ${session?.user.email}');
        final isadmin = await esAdmin(session?.user.email);
        if(isadmin){
          setState(() {
            logueado = true;
            admin = true;
                  debugPrint('Logueado: $logueado, Admin: $admin');

          });
        }else{
        setState(() {
                
          logueado = true;
          debugPrint('Logueado: $logueado, Admin: $admin');
        });
      }
        // 🔄 fuerza el rebuild, mostrando la UI de usuario logueado
      } else if (event == AuthChangeEvent.signedOut) {
        setState(() {
          logueado = false;
        }); // 🔄 vuelve a la UI de usuario no logueado
      }
      debugPrint('Evento auth: $event, usuario: ${session?.user?.email}');
    });
  }

 Future<bool> esAdmin(correo) async {
  
  
  if (correo == null) return false;

  final data = await supabase
      .from('Usuario')
      .select('Admin')
      .eq('Correo', correo)
      .maybeSingle();

  if (data == null) return false;
  return data['Admin'] == true;
}
  

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    Future.delayed(Duration(seconds: 10));
   if (admin && logueado) {
    Future.microtask(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
      );
    });
  }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Image.asset('images/Logo.png', fit: BoxFit.cover),
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
            if (!logueado) ...[
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sesion'),
                onTap: () {
                  //Aqui va el screen para iniciar sesion
                  mostrarLogin(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Crear Cuenta'),
                onTap: () {
                  //Aqui va el screen para crear una cuenta
                  mostrarRegistro(context);
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
              Image.asset('images/VistaPrincipal.jpg', width: double.infinity, height: 200, fit: BoxFit.cover),
              const SizedBox(height: 8),
              const Text(
                'Esta es la entrada principal de nuestro Hostel, rodeado de plantas naturales que acompañan bien con una hermosa iluminacion en las mañanas. Ademas, contamos con un pequeño estacionamiento alojado cerca de la entrada en caso de necesitar un lugar donde depositar sus vehiculos ',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Image.asset('images/Secundaria.jpg', width: double.infinity, height: 200, fit: BoxFit.cover),
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

  void mostrarLogin(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (_) => const Login(),
  );
}

 void mostrarRegistro(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (_) => const Registro(),
  );
}
}