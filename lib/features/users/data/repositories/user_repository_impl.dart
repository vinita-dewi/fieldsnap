import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  const UserRepositoryImpl(this.localDataSource);

  @override
  Future<List<UserProfile>> getUsers() {
    throw UnimplementedError('UserRepositoryImpl.getUsers not implemented');
  }
}
