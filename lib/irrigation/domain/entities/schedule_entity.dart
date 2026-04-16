import 'package:equatable/equatable.dart';

class Schedule extends Equatable {
  final int? id; // `id` ahora es opcional
  final int plotId;
  final double waterAmount; // Cantidad de agua en litros
  final double pressure; // Presión del agua en bares
  final double sprinklerRadius; // Radio del aspersor en metros
  final double expectedMoisture; // Humedad esperada en porcentaje
  final double estimatedTimeHours; // Tiempo estimado en horas
  final String setTime; // Hora programada para el riego
  final double angle; // Ángulo de riego en grados
  final bool isAutomatic; // Indica si el riego es automático

  const Schedule({
    this.id, // Hacemos opcional el `id`
    required this.plotId,
    required this.waterAmount,
    required this.pressure,
    required this.sprinklerRadius,
    required this.expectedMoisture,
    required this.estimatedTimeHours,
    required this.setTime,
    required this.angle,
    required this.isAutomatic,
  });

  @override
  List<Object?> get props => [
        id,
        plotId,
        waterAmount,
        pressure,
        sprinklerRadius,
        expectedMoisture,
        estimatedTimeHours,
        setTime,
        angle,
        isAutomatic,
      ];

  /// Crear un objeto `Schedule` desde un JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      plotId: json['plotId'],
      waterAmount: (json['waterAmount'] ?? 0).toDouble(),
      pressure: (json['pressure'] ?? 0).toDouble(),
      sprinklerRadius: (json['sprinklerRadius'] ?? 0).toDouble(),
      expectedMoisture: (json['expectedMoisture'] ?? 0).toDouble(),
      estimatedTimeHours: (json['estimatedTimeHours'] ?? 0).toDouble(),
      setTime: json['setTime'] ?? '',
      angle: (json['angle'] ?? 0).toDouble(),
      isAutomatic: json['isAutomatic'] ?? false,
    );
  }

  /// Convertir un objeto `Schedule` a JSON
  Map<String, dynamic> toJson() {
    return {
      'plotId': plotId,
      'waterAmount': waterAmount,
      'pressure': pressure,
      'sprinklerRadius': sprinklerRadius,
      'expectedMoisture': expectedMoisture,
      'estimatedTimeHours': estimatedTimeHours,
      'setTime': setTime,
      'angle': angle,
      'isAutomatic': isAutomatic,
    };
  }


  Schedule copyWith({
    int? id,
    int? plotId,
    double? waterAmount,
    double? pressure,
    double? sprinklerRadius,
    double? expectedMoisture,
    double? estimatedTimeHours,
    String? setTime,
    double? angle,
    bool? isAutomatic,
  }) {
    return Schedule(
      id: id ?? this.id,
      plotId: plotId ?? this.plotId,
      waterAmount: waterAmount ?? this.waterAmount,
      pressure: pressure ?? this.pressure,
      sprinklerRadius: sprinklerRadius ?? this.sprinklerRadius,
      expectedMoisture: expectedMoisture ?? this.expectedMoisture,
      estimatedTimeHours: estimatedTimeHours ?? this.estimatedTimeHours,
      setTime: setTime ?? this.setTime,
      angle: angle ?? this.angle,
      isAutomatic: isAutomatic ?? this.isAutomatic,
    );
  }

}