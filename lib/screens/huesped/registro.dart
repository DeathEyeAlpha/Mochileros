import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _DialogRegistroState();
}

class _DialogRegistroState extends State<Registro> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  bool _cargando = false;
  String? _error;

  Future<void> _registrarUsuario() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (res.user != null) {
        //  Registro exitoso
        try {
        final supabase = Supabase.instance.client;
        final response = await supabase.from('Usuario').insert({
    'Nombre': _nombreController.text.trim(),
    'Correo': _emailController.text.trim(),
    'Cedula': _cedulaController.text.trim(),
  });
  debugPrint('✅ Usuario guardado en tabla Usuario');
        }catch (e) {
          debugPrint('❌ Error al guardar en tabla Usuario: $e');
        }
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario registrado: ${res.user!.email}')),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Registrar nuevo usuario', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            TextField(
              controller: _nombreController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _cedulaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Cédula'),
            ),
            const SizedBox(height: 16),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            FilledButton(
              onPressed: _cargando ? null : _registrarUsuario,
              child: _cargando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
