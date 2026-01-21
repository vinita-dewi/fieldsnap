import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<List<UserProfile>> getUsers({required int limit, required int skip});
}
