import '../domain/entities/auth_entity.dart';
import '../infrastructure/data_sources/user_data_source.dart';

class AuthService {
  final UserDataSource dataSource;

  AuthService({required this.dataSource});

  Future<UserAuth?> login(String email, String password) async {
    return await dataSource.getUserByEmailAndPassword(email, password);
  }

  Future<UserAuth?> signup(UserAuth newUser) async {
    return await dataSource.addUser(newUser);
  }

  Future<int?> getLastUserId() async {
    return await dataSource.getLastUserId();
  }
}
