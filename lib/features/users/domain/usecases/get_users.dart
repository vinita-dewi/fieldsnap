import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

class GetUsersParams {
  final int limit;
  final int skip;

  const GetUsersParams({required this.limit, required this.skip});
}

class GetUsers implements UseCase<List<UserProfile>, GetUsersParams> {
  final UserRepository repository;
  const GetUsers(this.repository);

  @override
  Future<List<UserProfile>> call(GetUsersParams params) {
    return repository.getUsers(limit: params.limit, skip: params.skip);
  }
}
