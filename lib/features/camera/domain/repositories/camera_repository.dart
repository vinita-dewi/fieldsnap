import '../entities/captured_photo.dart';

abstract class CameraRepository {
  Future<CapturedPhoto> capturePhoto();
}