import '../../../../core/usecases/usecase.dart';
import '../entities/captured_photo.dart';
import '../repositories/camera_repository.dart';

class CapturePhoto implements UseCase<CapturedPhoto, NoParams> {
  final CameraRepository repository;
  const CapturePhoto(this.repository);

  @override
  Future<CapturedPhoto> call(NoParams params) {
    return repository.capturePhoto();
  }
}