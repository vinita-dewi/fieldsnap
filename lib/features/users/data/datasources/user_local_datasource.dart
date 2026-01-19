import '../../domain/entities/user_profile.dart';

abstract class UserLocalDataSource {
  Future<List<UserProfile>> getUsers();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<List<UserProfile>> getUsers() async {
    throw UnimplementedError('UserLocalDataSourceImpl.getUsers not implemented');
  }
}
