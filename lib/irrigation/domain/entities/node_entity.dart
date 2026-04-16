class Node {
  final String location;
  final int moisture;
  final String indicator;
  final String status;

  Node({
    required this.location,
    required this.moisture,
    required this.indicator,
    required this.status,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      location: json['location'],
      moisture: json['moisture'],
      indicator: json['indicator'],
      status: json['status'],
    );
  }
}