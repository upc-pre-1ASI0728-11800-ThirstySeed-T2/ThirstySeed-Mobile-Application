import 'package:flutter/material.dart';
import 'package:thirstyseed/common/user_session.dart';
import '../application/profile_service.dart';
import '../domain/entities/profile_entity.dart';
import '../../subscription/presentation/select_plan_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  final ProfileService profileService;

  const CreateProfileScreen({
    Key? key,
    required this.profileService,
  }) : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _showChoosePlanButton = false; // Estado para controlar la visibilidad del botón

  Future<void> _createProfile() async {
    try {
      final newProfile = ProfileEntityPost(
        userId: UserSession().getUserId()?? 0,
        firstName: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _telephoneController.text.trim(),
        profileImage: _imageUrlController.text.trim(),
        location: _cityController.text.trim(),
      );

      final success = await widget.profileService.createProfile(newProfile);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil creado exitosamente')),
        );
        setState(() {
          _showChoosePlanButton = true; // Mostrar el botón al tener éxito
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocurrió un error al crear el perfil')),
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
              const Icon(Icons.account_circle, size: 120, color: Colors.black),
              const SizedBox(height: 24),
              const Text(
                'Create Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const Divider(color: Colors.black, thickness: 1, indent: 40, endIndent: 40, height: 30),
              _buildTextField(_nameController, 'First Name'),
              _buildTextField(_lastNameController, 'Last Name'),
              _buildTextField(_cityController, 'City'),
              _buildTextField(_telephoneController, 'Telephone'),
              _buildTextField(_emailController, 'Email'),
              _buildTextField(_imageUrlController, 'Image URL'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Create Profile', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              if (_showChoosePlanButton) // Mostrar el botón solo si la variable es true
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectPlanScreen(userId: UserSession().getUserId()?? 0),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Choose Plan', style: TextStyle(fontSize: 16, color: Colors.white)),
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