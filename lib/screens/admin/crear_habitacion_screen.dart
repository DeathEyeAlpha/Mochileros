// lib/screens/admin/crear_habitacion_screen.dart


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mochileros/main.dart';
import '../../models/habitacion.dart';
import '../../services/interfaces/i_habitacion_service.dart';
import '../../services/implementacion/habitacion_service.dart';

class CrearHabitacionScreen extends StatefulWidget {
  const CrearHabitacionScreen({Key? key}) : super(key: key);
  
  @override
  State<CrearHabitacionScreen> createState() => _CrearHabitacionScreenState();
}

class _CrearHabitacionScreenState extends State<CrearHabitacionScreen> {
  List<String> imagenes = [
    'https://ba-h.com.ar/wp-content/uploads/2018/10/10-ventajas-alojarse-hostel_2.jpg',
    'https://lh6.googleusercontent.com/proxy/M1A6uvYwv-9p8t8ulaNwVce8brFiothPnBxaq0N9f8JUNP4BHP2FVBiph3NqtiyFWNaP3CNgm93pyJzBzNhvjrHqZAbZzVWYN2jk3hJlomWwpfq0',
    'https://upload.wikimedia.org/wikipedia/commons/e/e8/Hostel_Dormitory.jpg',
    'https://www.latroupe.com/content/imgsxml/textos_internos/a_shared_dormitory_in_a_modern_hostel_featuring_b.jpg',
  ];
  //instancia del servicio
  final IHabitacionService _habitacionService = HabitacionService();
  final _formKey = GlobalKey<FormState>();
  
  //controladores y variables de estado
  final _tituloController = TextEditingController();
  final _precioController = TextEditingController();
  final _descripcionController = TextEditingController();
  int _cantidadCuartos = 1;
  int _cantidadCamas = 1;
  int _cantidadTelevisores = 0;
  int _cantidadBanos = 1;
  List<String> _serviciosSeleccionados = [];
  final List<String> _serviciosDisponibles = ['WiFi', 'Aire Acondicionado', 'Jacuzzi']; // etc.
  
  @override
  void dispose() {
    _tituloController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  //metodo para crear la habitación usando el servicio
  void _crearHabitacion() async {
    if (_formKey.currentState!.validate()) {
      //creamos un objeto Habitacion con los datos del formulario
      final nuevaHabitacion = Habitacion(
        numero: 0, //el ID real será asignado por el servicio
        nombre: _tituloController.text,
        precio: double.parse(_precioController.text),
        descripcion: _descripcionController.text,
        cuartos: _cantidadCuartos,
        camas: _cantidadCamas,
        televisores: _cantidadTelevisores,
        banos: _cantidadBanos,
        //por ahora una imagen de placeholder, la logica para subir imagenes es mas compleja
        imagenes: imagenes, 
      );

      //llamamos al servicio para crear la habitación
      try{
      await supabase
        .from('Habitacion')
        .insert({
          'Nombre': nuevaHabitacion.nombre,
          'Precio': nuevaHabitacion.precio,
          'Descripcion': nuevaHabitacion.descripcion,
          'Cuartos': nuevaHabitacion.cuartos,
          'Camas': nuevaHabitacion.camas,
          'Televisores': nuevaHabitacion.televisores,
          'Baños': nuevaHabitacion.banos,
          'Imagen': nuevaHabitacion.imagenes.elementAt(Random().nextInt(nuevaHabitacion.imagenes.length)),
          'Servicios': _serviciosSeleccionados,
        });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text( 'Habitación creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al crear la habitación: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        
          
        
      
    }
  }

  void _mostrarSelectorServicios() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seleccionar Servicios',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _serviciosDisponibles.length,
                      itemBuilder: (context, index) {
                        final servicio = _serviciosDisponibles[index];
                        final isSelected = _serviciosSeleccionados.contains(servicio);
                        
                        return CheckboxListTile(
                          title: Text(servicio),
                          value: isSelected,
                          activeColor: const Color(0xFF6B5FB5),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                _serviciosSeleccionados.add(servicio);
                              } else {
                                _serviciosSeleccionados.remove(servicio);
                              }
                            });
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B5FB5),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Confirmar', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFE8E5F0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(Icons.edit, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required int value,
    required List<int> items,
    required Function(int?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF6B5FB5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF6B5FB5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<int>(
              value: value,
              dropdownColor: const Color(0xFF6B5FB5),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: items.map((int item) {
                return DropdownMenuItem<int>(
                  value: item,
                  child: Text(item.toString()),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        //cambiamos el icono de perfil por la flecha para volver
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: const Text('Crear Habitación', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'Título',
                controller: _tituloController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingrese un título';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Precio',
                controller: _precioController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingrese un precio';
                  if (double.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Descripción',
                controller: _descripcionController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Por favor ingrese una descripción';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownButton(
                      label: 'Cuartos',
                      value: _cantidadCuartos,
                      items: List.generate(10, (index) => index + 1),
                      onChanged: (value) => setState(() => _cantidadCuartos = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownButton(
                      label: 'Televisores',
                      value: _cantidadTelevisores,
                      items: List.generate(11, (index) => index),
                      onChanged: (value) => setState(() => _cantidadTelevisores = value!),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownButton(
                      label: 'Camas',
                      value: _cantidadCamas,
                      items: List.generate(20, (index) => index + 1),
                      onChanged: (value) => setState(() => _cantidadCamas = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdownButton(
                      label: 'Baños',
                      value: _cantidadBanos,
                      items: List.generate(10, (index) => index + 1),
                      onChanged: (value) => setState(() => _cantidadBanos = value!),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: ElevatedButton.icon(
                    onPressed: _mostrarSelectorServicios,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text('Servicios ${_serviciosSeleccionados.isNotEmpty ? "(${_serviciosSeleccionados.length})" : ""}', style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B5FB5),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //sacamos la fila de botones y dejamos solo uno que ocupa todo el ancho
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _crearHabitacion,
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Crear Habitación',
                    style: TextStyle(color: Colors.white, fontSize: 16)
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B5FB5),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}