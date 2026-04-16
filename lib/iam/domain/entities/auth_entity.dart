class UserAuth {
  final int id; // Agregado
  final String email;
  final String password;

  UserAuth({
    required this.id, // Agregado
    required this.email,
    required this.password,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      id: json['id'] ?? 0, // Agregado
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Agregado
      'email': email,
      'password': password,
    };
  }
}

  

