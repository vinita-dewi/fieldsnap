import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

class GetUsers implements UseCase<List<UserProfile>, NoParams> {
  final UserRepository repository;
  const GetUsers(this.repository);

  @override
  Future<List<UserProfile>> call(NoParams params) {
    return repository.getUsers();
  }
}
