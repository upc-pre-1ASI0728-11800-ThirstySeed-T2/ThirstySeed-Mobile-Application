import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/schedule_entity.dart';

class ScheduleDataSource {
  final String baseUrl = 'https://thirstyseedapi-production.up.railway.app/api/v1/schedules';

  Future<bool> createSchedule(Schedule schedule) async {
    final body = json.encode(schedule.toJson());
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response.statusCode == 201;
  }

  Future<Schedule> getScheduleById(int scheduleId) async {
    final response = await http.get(Uri.parse('$baseUrl/$scheduleId'));
    if (response.statusCode == 200) {
      return Schedule.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el horario de riego');
    }
  }

  Future<List<Schedule>> getAllSchedules() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> schedulesJson = json.decode(response.body);
      return schedulesJson.map((json) => Schedule.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los horarios de riego');
    }
  }

  Future<List<Schedule>> getSchedulesByUserId(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> schedulesJson = json.decode(response.body);
      return schedulesJson.map((json) => Schedule.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener los horarios de riego para el usuario');
    }
  }

  Future<bool> updateSchedule(int scheduleId, Schedule schedule) async {
    final body = json.encode(schedule.toJson());
    final response = await http.put(
      Uri.parse('$baseUrl/$scheduleId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteSchedule(int scheduleId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$scheduleId'));
    return response.statusCode == 200;
  }
}
