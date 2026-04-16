
import 'package:thirstyseed/common/user_session.dart';
import 'package:thirstyseed/irrigation/domain/entities/plot_entity.dart';
import 'package:thirstyseed/irrigation/infrastructure/repositories/plot_repository.dart';

class PlotService {
  final PlotRepository repository;

  PlotService({required this.repository});

  Future<List<Plot>> getPlotsByUserId() async {
    try {
      final userId = UserSession().getUserId();
      if (userId == null) throw Exception('User ID no encontrado');
      return await repository.getPlotsByUserId(userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Plot> getPlotById(int id) async {
    try {
      return await repository.getPlotById(id);
    } catch (e) {
      rethrow;
    }
  }
}