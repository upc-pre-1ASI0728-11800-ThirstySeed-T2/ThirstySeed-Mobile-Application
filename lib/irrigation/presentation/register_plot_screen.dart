import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_node_screen.dart'; // Importa la pantalla de registro de nodos

class RegisterPlotScreen extends StatefulWidget {
  final int userId;

  const RegisterPlotScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _RegisterPlotScreenState createState() => _RegisterPlotScreenState();
}

class _RegisterPlotScreenState extends State<RegisterPlotScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _extensionController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  String? _imageUrl;
  bool _isSubmitting = false;

  Future<void> _registerPlot() async {
    if (_nameController.text.isEmpty || _locationController.text.isEmpty ||
        _extensionController.text.isEmpty || _sizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://thirstyseedapi-production.up.railway.app/api/v1/plot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': widget.userId,
          'name': _nameController.text.trim(),
          'location': _locationController.text.trim(),
          'extension': int.tryParse(_extensionController.text) ?? 0,
          'size': int.tryParse(_sizeController.text) ?? 0,
          'imageUrl': _imageUrl ?? '',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final int? plotId = responseBody['id'];

        if (plotId != null) {
          // Navegar a RegisterNodeScreen inmediatamente después de un registro exitoso
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterNodeScreen(plotId: plotId, userId: widget.userId),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Parcela registrada con éxito')),
          );
        } else {
          throw Exception('El ID de la parcela no se encontró en la respuesta');
        }
      } else {
        throw Exception('Error al registrar la parcela: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _updateImagePreview() {
    setState(() {
      _imageUrl = _imageUrlController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: const Text(
          'Registrar parcela',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_imageUrlController, 'URL de la Imagen', 'Ingrese la URL de la imagen'),
            const SizedBox(height: 20),
            _imageUrlPreview(),
            _buildTextField(_nameController, 'Nombre de Terreno', 'Nombre De Terreno'),
            _buildTextField(_locationController, 'Ubicación', 'Ubicación'),
            _buildTextField(_extensionController, 'Extensión', 'Extensión', numeric: true),
            _buildTextField(_sizeController, 'Tamaño (Size)', 'Tamaño de la parcela', numeric: true),
            const SizedBox(height: 30),
            if (_isSubmitting)
              const Center(child: CircularProgressIndicator())
            else
              _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _imageUrlPreview() {
    return _imageUrl != null && _imageUrl!.isNotEmpty
        ? Image.network(_imageUrl!, height: 150, fit: BoxFit.cover)
        : const Text('No image selected');
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String placeholder,
      {bool numeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: (_) => numeric ? null : _updateImagePreview(),
          keyboardType: numeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.green[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _registerPlot,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Registrar Parcela', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}