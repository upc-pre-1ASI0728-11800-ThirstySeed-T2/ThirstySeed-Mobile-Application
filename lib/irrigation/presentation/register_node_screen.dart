import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Clase para manejar el estado global
class SubscriptionManager {
  static bool isCodeValidated = false;
  static int remainingNodes = 0;
  static String validationCode = '';
}

class RegisterNodeScreen extends StatefulWidget {
  final int plotId;
  final int userId;

  const RegisterNodeScreen({Key? key, required this.plotId, required this.userId}) : super(key: key);

  @override
  _RegisterNodeScreenState createState() => _RegisterNodeScreenState();
}

class _RegisterNodeScreenState extends State<RegisterNodeScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _moistureController = TextEditingController();
  final TextEditingController _indicatorController = TextEditingController();
  final TextEditingController _statusController = TextEditingController(text: 'true');
  final TextEditingController _productcodeController = TextEditingController();
  final TextEditingController _validationCodeController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _validateCode() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final url = Uri.parse('https://thirstyseedapi-production.up.railway.app/api/v1/subscriptions/user/${widget.userId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (_validationCodeController.text.trim() == data['validationCode']) {
          setState(() {
            SubscriptionManager.remainingNodes = data['nodeCount'];
            SubscriptionManager.isCodeValidated = true;
            SubscriptionManager.validationCode = data['validationCode'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Código validado con éxito')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El código no es válido')),
          );
        }
      } else {
        throw Exception('Error al validar el código');
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

  Future<void> _registerNode() async {
    if (SubscriptionManager.remainingNodes <= 0) {
      _showOutOfNodesDialog();
      return;
    }

    if (_locationController.text.isEmpty ||
        _moistureController.text.isEmpty ||
        _indicatorController.text.isEmpty ||
        _statusController.text.isEmpty ||
        _productcodeController.text.isEmpty) {
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
        Uri.parse('https://thirstyseedapi-production.up.railway.app/api/v1/node'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'plotId': widget.plotId,
          'nodelocation': _locationController.text.trim(),
          'moisture': int.tryParse(_moistureController.text.trim()) ?? 0,
          'indicator': _indicatorController.text.trim(),
          'isActive': _statusController.text.trim().toLowerCase() == 'true',
          'productcode': _productcodeController.text.trim(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          SubscriptionManager.remainingNodes--;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nodo registrado con éxito')),
        );
      } else {
        throw Exception('Error al registrar nodo: ${response.body}');
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

  void _showOutOfNodesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nodos agotados'),
          content: const Text('Ya no tienes nodos disponibles. Por favor, adquiere más nodos para continuar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Aquí se podría agregar funcionalidad de pago
              },
              child: const Text('Pagar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: const Text(
          'Registrar Nodo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!SubscriptionManager.isCodeValidated)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ingrese código de validación:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _validationCodeController,
                    decoration: InputDecoration(
                      hintText: 'Código de validación',
                      filled: true,
                      fillColor: Colors.green[50],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _validateCode,
                    child: const Text('Validar código'),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    'Nodos restantes: ${SubscriptionManager.remainingNodes}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(_locationController, 'Nombre de la locacion', 'Nombre De la locacion'),
                  _buildTextField(_moistureController, 'Humedad', 'Humedad', numeric: true),
                  _buildTextField(_indicatorController, 'Indicador', 'Indicador'),
                  _buildTextField(_statusController, 'Estado', 'Estado'),
                  _buildTextField(_productcodeController, 'Código de producto', 'Código de producto'),
                  const SizedBox(height: 30),
                  if (_isSubmitting)
                    const Center(child: CircularProgressIndicator())
                  else
                    _buildButtons(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String placeholder, {bool numeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: numeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.green[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
          onPressed: SubscriptionManager.remainingNodes > 0 ? _registerNode : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Registrar Nodo', style: TextStyle(color: Colors.white)),
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