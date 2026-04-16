class UserSession {
  static final UserSession _instance = UserSession._internal();
  int? _userId;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  // Método para establecer el User ID
  void setUserId(int userId) {
    _userId = userId;
  }

  // Método para obtener el User ID
  int? getUserId() {
    return _userId;
  }

  // Método para limpiar el User ID
  void clearUserId() {
    _userId = null;
  }
}