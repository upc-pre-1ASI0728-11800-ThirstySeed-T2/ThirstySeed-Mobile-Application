import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart'; // Para copiar al portapapeles
import 'package:thirstyseed/iam/application/auth_service.dart';
import 'package:thirstyseed/iam/presentation/login_screen.dart';
import 'package:thirstyseed/profile/domain/entities/profile_entity.dart';

class AccountScreen extends StatefulWidget {
  final ProfileEntityGet user;
  final AuthService authService;

  const AccountScreen({Key? key, required this.user, required this.authService}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? validationCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchValidationCode();
  }

  Future<void> _fetchValidationCode() async {
    final url = Uri.parse(
        'https://thirstyseedapi-production.up.railway.app/api/v1/subscriptions/user/${widget.user.id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          validationCode = data['validationCode'];
          isLoading = false;
        });
      } else {
        setState(() {
          validationCode = 'Error al obtener el código';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        validationCode = 'Error de conexión';
        isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    if (validationCode != null && validationCode != 'Error al obtener el código' && validationCode != 'Error de conexión') {
      Clipboard.setData(ClipboardData(text: validationCode.toString()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código copiado al portapapeles')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay código disponible para copiar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.green[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.user.profileImage),
            ),
            const SizedBox(height: 16.0),
            _buildProfileInfoRow(icon: Icons.person, text: widget.user.fullName),
            _buildProfileInfoRow(icon: Icons.phone, text: widget.user.phoneNumber),
            _buildProfileInfoRow(icon: Icons.email, text: widget.user.email),
            _buildProfileInfoRow(icon: Icons.location_on, text: widget.user.location),
            const SizedBox(height: 20.0),
            _buildSectionHeader(icon: Icons.code, title: "Código"),
            const SizedBox(height: 10.0),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          validationCode ?? 'Sin código',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.green),
                        onPressed: _copyToClipboard,
                      ),
                    ],
                  ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(authService: widget.authService),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 182, 48, 25),
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Salir', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
