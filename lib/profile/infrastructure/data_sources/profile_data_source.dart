import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/profile_entity.dart';

class ProfileDataSource {
  final String baseUrl = 'https://thirstyseedapi-production.up.railway.app/api/v1';

  Future<bool> createProfile(ProfileEntityPost profile) async {
    final body = json.encode(profile.toJson());
    print('Datos enviados al API de perfiles: $body'); // Debug

    final response = await http.post(
      Uri.parse('$baseUrl/profiles'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('Respuesta de la API: ${response.statusCode} - ${response.body}'); // Debug
    return response.statusCode == 201;
  }

  Future<ProfileEntityGet> getProfileByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/profiles/user/$userId'));
    if (response.statusCode == 200) {
      return ProfileEntityGet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el perfil');
    }
  }
}
