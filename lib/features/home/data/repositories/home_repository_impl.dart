import '../../domain/entities/home_action.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;
  const HomeRepositoryImpl(this.localDataSource);

  @override
  Future<List<HomeAction>> getActions() {
    throw UnimplementedError('HomeRepositoryImpl.getActions not implemented');
  }
}
