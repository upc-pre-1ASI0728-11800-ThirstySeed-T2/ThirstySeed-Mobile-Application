import 'package:thirstyseed/irrigation/domain/entities/node_entity.dart';

class Plot {
  final int id;
  final int userId;
  final String name;
  final String location;
  final int extension;
  final int size;
  final String status; // Solo disponible en GET, opcional en POST
  final String imageUrl;
  final String createdAt; // Solo disponible en GET
  final String updatedAt; // Solo disponible en GET
  final List<Node>? nodes; // Solo disponible en GET, opcional
  final int? installedNodes; // Solo disponible en GET, opcional

  Plot({
    required this.id,
    required this.userId,
    required this.name,
    required this.location,
    required this.extension,
    required this.size,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.nodes,
    this.installedNodes,
  });

  factory Plot.fromJson(Map<String, dynamic> json) {
    return Plot(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      location: json['location'],
      extension: json['extension'],
      size: json['size'],
      status: json['status'] ?? 'Desconocido',
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      nodes: json.containsKey('nodes')
          ? (json['nodes'] as List).map((nodeJson) => Node.fromJson(nodeJson)).toList()
          : null,
      installedNodes: json['installedNodes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'location': location,
      'extension': extension,
      'size': size,
      'imageUrl': imageUrl,
    };
  }
}
