import 'package:thirstyseed/irrigation/domain/entities/schedule_entity.dart';
import 'package:thirstyseed/irrigation/infrastructure/data_sources/schedule_data_source.dart';

class ScheduleRepository {
  final ScheduleDataSource dataSource;

  ScheduleRepository({required this.dataSource});

  Future<bool> createSchedule(Schedule schedule) async {
    try {
      return await dataSource.createSchedule(schedule);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Schedule> getScheduleById(int scheduleId) async {
    try {
      return await dataSource.getScheduleById(scheduleId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Schedule>> getAllSchedules() async {
    try {
      return await dataSource.getAllSchedules();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Schedule>> getSchedulesByUserId(int userId) async {
    try {
      return await dataSource.getSchedulesByUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateSchedule(int scheduleId, Schedule schedule) async {
    try {
      return await dataSource.updateSchedule(scheduleId, schedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteSchedule(int scheduleId) async {
    try {
      return await dataSource.deleteSchedule(scheduleId);
    } catch (e) {
      rethrow;
    }
  }
}
