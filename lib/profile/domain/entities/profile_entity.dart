class ProfileEntityPost {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String location;

  ProfileEntityPost({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.location,
  });

  /// Convertir un objeto `ProfileEntityPost` a JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'location': location,
    };
  }
}

class ProfileEntityGet {
  final int id;
  final int userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String location;

  ProfileEntityGet({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.location,
  });

  /// Crear un objeto `ProfileEntityGet` desde un JSON
  factory ProfileEntityGet.fromJson(Map<String, dynamic> json) {
    return ProfileEntityGet(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      location: json['location'] ?? '',
    );
  }
}