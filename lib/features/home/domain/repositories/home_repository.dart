import '../entities/home_action.dart';

abstract class HomeRepository {
  Future<List<HomeAction>> getActions();
}