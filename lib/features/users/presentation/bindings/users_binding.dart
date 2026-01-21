import 'package:fieldsnap/core/services/api_service.dart';
import 'package:fieldsnap/features/users/data/datasources/user_local_datasource.dart';
import 'package:fieldsnap/features/users/data/datasources/user_remote_datasource.dart';
import 'package:fieldsnap/features/users/data/repositories/user_repository_impl.dart';
import 'package:fieldsnap/features/users/domain/usecases/get_users.dart';
import 'package:fieldsnap/features/users/presentation/controllers/users_controller.dart';
import 'package:get/get.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() {
      final apiService = ApiService();
      final remoteDataSource = UserRemoteDataSourceImpl(apiService);
      final localDataSource = UserLocalDataSourceImpl();
      final repository = UserRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
      );

      return UsersController(getUsers: GetUsers(repository));
    });
  }
}
