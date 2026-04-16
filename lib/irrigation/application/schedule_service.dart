import 'package:thirstyseed/common/user_session.dart';
import 'package:thirstyseed/irrigation/domain/entities/schedule_entity.dart';
import 'package:thirstyseed/irrigation/infrastructure/repositories/schedule_repository.dart';

class ScheduleService {
  final ScheduleRepository repository;

  ScheduleService({required this.repository});

  Future<bool> createSchedule(Schedule schedule) async {
    try {
      return await repository.createSchedule(schedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<Schedule> getScheduleById(int scheduleId) async {
    try {
      return await repository.getScheduleById(scheduleId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Schedule>> getAllSchedules() async {
    try {
      return await repository.getAllSchedules();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Schedule>> getSchedulesByUserId() async {
    try {
      final userId = UserSession().getUserId();
      if (userId == null) throw Exception('User ID no encontrado');
      return await repository.getSchedulesByUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateSchedule(int scheduleId, Schedule schedule) async {
    try {
      return await repository.updateSchedule(scheduleId, schedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteSchedule(int scheduleId) async {
    try {
      return await repository.deleteSchedule(scheduleId);
    } catch (e) {
      rethrow;
    }
  }
}
