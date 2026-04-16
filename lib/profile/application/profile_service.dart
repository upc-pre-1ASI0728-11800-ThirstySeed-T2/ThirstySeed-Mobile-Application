import '../domain/entities/profile_entity.dart';
import '../infrastructure/data_sources/profile_data_source.dart';

class ProfileService {
  final ProfileDataSource dataSource;
  static int _userIdCounter = 1; // Comenzar desde 1

  ProfileService({required this.dataSource});

  Future<bool> createProfile(ProfileEntityPost profile) async {
    return await dataSource.createProfile(profile);
  }

  /// Método para obtener un nuevo `userId`
  int getNextUserId() {
    return _userIdCounter++;
  }
}
