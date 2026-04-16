import 'package:flutter/material.dart';
import 'package:thirstyseed/common/user_session.dart';
import 'package:thirstyseed/iam/presentation/create_account_screen.dart';
import '../application/auth_service.dart';
import '../../ui/screens/menu_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthService authService;

  const LoginScreen({Key? key, required this.authService}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
  final user = await widget.authService.login(
    _emailController.text,
    _passwordController.text,
  );
  if (user != null) {
    UserSession().setUserId(user.id); // Guardamos el userId en la sesión

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(authService: widget.authService, currentUser: user),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bienvenido, ${user.email}!')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario no encontrado o contraseña incorrecta')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Esto evita que la app se cierre al retroceder
        return false;
      },
      child: Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 150),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Thirsty Seed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              const SizedBox(height: 24),
              _buildTextField(_emailController, 'Email'),
              const SizedBox(height: 16),
              _buildTextField(_passwordController, 'Password', obscureText: true),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Acción para recuperar contraseña
                },
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Log In'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccountScreen(authService: widget.authService),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Sign Up', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ));
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
