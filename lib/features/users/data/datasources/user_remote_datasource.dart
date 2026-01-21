import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:fieldsnap/core/services/api_service.dart';
import 'package:fieldsnap/core/utils/api_constants.dart';
import '../../domain/models/user_profile_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserProfileModel>> getUsers({
    required int limit,
    required int skip,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiService apiService;
  final _log = AppLogger.instance;

  UserRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<UserProfileModel>> getUsers({
    required int limit,
    required int skip,
  }) async {
    try {
      final response = await apiService.request(
        path: ApiConstants.getUsers,
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );
      final users = (response.data as Map<String, dynamic>?)?['users'];
      if (users is List) {
        return users
            .whereType<Map<String, dynamic>>()
            .map(UserProfileModel.fromJson)
            .toList();
      }
      return const [];
    } catch (e) {
      _log.e('[UserRemoteDataSource.getUsers] $e');
      rethrow;
    }
  }
}
