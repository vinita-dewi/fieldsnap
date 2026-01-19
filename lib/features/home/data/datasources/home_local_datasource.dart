import '../../domain/entities/home_action.dart';

abstract class HomeLocalDataSource {
  Future<List<HomeAction>> getActions();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<HomeAction>> getActions() async {
    throw UnimplementedError('HomeLocalDataSourceImpl.getActions not implemented');
  }
}
