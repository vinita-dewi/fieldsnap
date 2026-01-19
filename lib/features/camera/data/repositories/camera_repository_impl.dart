import '../../domain/entities/captured_photo.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_local_datasource.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraLocalDataSource localDataSource;
  const CameraRepositoryImpl(this.localDataSource);

  @override
  Future<CapturedPhoto> capturePhoto() async {
    throw UnimplementedError('CameraRepositoryImpl.capturePhoto not implemented');
  }
}
