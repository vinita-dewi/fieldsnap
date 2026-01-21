import 'package:fieldsnap/core/logging/app_logger.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/models/user_profile_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;
  final UserRemoteDataSource remoteDataSource;
  final _log = AppLogger.instance;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<UserProfile>> getUsers({
    required int limit,
    required int skip,
  }) async {
    try {
      final List<UserProfileModel> models = await remoteDataSource.getUsers(
        limit: limit,
        skip: skip,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      _log.e('[UserRepositoryImpl.getUsers] $e');
      rethrow;
    }
  }
}
