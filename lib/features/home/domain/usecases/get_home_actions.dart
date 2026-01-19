import '../../../../core/usecases/usecase.dart';
import '../entities/home_action.dart';
import '../repositories/home_repository.dart';

class GetHomeActions implements UseCase<List<HomeAction>, NoParams> {
  final HomeRepository repository;
  const GetHomeActions(this.repository);

  @override
  Future<List<HomeAction>> call(NoParams params) {
    return repository.getActions();
  }
}