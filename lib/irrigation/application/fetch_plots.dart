// lib/catalog/application/fetch_plots.dart
import '../domain/entities/plot_entity.dart';
import '../infrastructure/repositories/plot_repository.dart';

class FetchPlots {
  final PlotRepository repository;

  FetchPlots(this.repository);

  Future<List<Plot>> call() async {
    return await repository.getPlots();
  }
}