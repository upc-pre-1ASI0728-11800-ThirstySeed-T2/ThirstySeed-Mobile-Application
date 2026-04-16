import 'package:flutter/material.dart';
import 'package:thirstyseed/common/user_session.dart';
import '../application/auth_service.dart';
import '../domain/entities/auth_entity.dart';
import '../../profile/presentation/create_profile_screen.dart';
import '../../profile/application/profile_service.dart';
import '../../profile/infrastructure/data_sources/profile_data_source.dart';

class CreateAccountScreen extends StatefulWidget {
  final AuthService authService;

  const CreateAccountScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Método para manejar el registro
  void _signup() async {
    try {
      final newUser = UserAuth(
        id:0,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

    final createdUser = await widget.authService.signup(newUser);

       if (createdUser != null) {
        UserSession().setUserId(createdUser.id);
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada exitosamente')),
      );
        // Navega a la pantalla de creación de perfil
         Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateProfileScreen(
            profileService: ProfileService(
              dataSource: ProfileDataSource(),
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El usuario ya existe o ocurrió un error')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 120, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(height: 24),
              const Text(
                'Create Your Account Credentials',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 76, 175, 80)),
              ),
          
              const Divider(color: Colors.black, thickness: 1, indent: 40, endIndent: 40, height: 30),
              const SizedBox(height: 24),
              _buildTextField(_emailController, 'Email'),
              const SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password', obscureText: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Sign up', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.green)),
      ),
    );
  }
}
