import '../../domain/entities/user_profile.dart';

abstract class UserLocalDataSource {
  Future<List<UserProfile>> getUsers({required int limit, required int skip});
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  Future<List<UserProfile>> getUsers({
    required int limit,
    required int skip,
  }) async {
    throw UnimplementedError('UserLocalDataSourceImpl.getUsers not implemented');
  }
}
