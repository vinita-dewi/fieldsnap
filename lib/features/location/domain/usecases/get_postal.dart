import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

class GetPostal implements UseCase<List<String>, String> {
  final LocationRepository repository;
  const GetPostal(this.repository);

  @override
  Future<List<String>> call(String code) {
    return repository.getPostal(code);
  }
}
