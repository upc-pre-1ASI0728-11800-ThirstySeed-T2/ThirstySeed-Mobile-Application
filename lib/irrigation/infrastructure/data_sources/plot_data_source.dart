// lib/irrigation/infrastructure/data_sources/plot_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import '../../domain/entities/plot_entity.dart';

class PlotDataSource {
  Future<List<Plot>> fetchPlots() async {
    final jsonString = await rootBundle.loadString('server/db.json');
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    return (jsonData['plots'] as List).map((plotJson) {
      return Plot.fromJson(plotJson);
    }).toList();
  }

  final String baseUrl = 'https://thirstyseedapi-production.up.railway.app/api/v1/plot';
  
  Future<List<Plot>> getPlotsByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> plotsJson = json.decode(response.body);
      return plotsJson.map((json) => Plot.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los plots para el usuario');
    }
  }

  // Get plot by id
  Future<Plot> getPlotById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> plotJson = json.decode(response.body);
      return Plot.fromJson(plotJson);
    } else {
      throw Exception('Error al obtener el plot');
    }
  }
}