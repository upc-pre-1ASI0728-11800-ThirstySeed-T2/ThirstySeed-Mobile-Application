import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/auth_entity.dart';

class UserDataSource {
  final String baseUrl = 'https://thirstyseedapi-production.up.railway.app/api/v1';

  // Método para iniciar sesión con la API real
  Future<UserAuth?> getUserByEmailAndPassword(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserAuth.fromJson(data);
    } else {
      return null;
    }
  }

  // Método para registrarse con la API real
  Future<UserAuth?> addUser(UserAuth newUser) async {
  final response = await http.post(
    Uri.parse('$baseUrl/authentication/sign-up'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'username': newUser.email,
      'password': newUser.password,
    }),
  );

  if (response.statusCode == 201) {
    final data = json.decode(response.body);
    return UserAuth.fromJson(data);
  } else {
    return null;
  }
}

Future<int?> getLastUserId() async {
  final response = await http.get(
    Uri.parse('$baseUrl/users'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as List<dynamic>;

    // Si hay usuarios, retorna el ID del último usuario
    if (data.isNotEmpty) {
      final lastUser = data.last;
      return lastUser['id'] as int?;
    }
  }

  // Si algo falla, retorna null
  return null;
}
}

