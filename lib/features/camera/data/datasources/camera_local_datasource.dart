import 'package:image_picker/image_picker.dart';

abstract class CameraLocalDataSource {
  Future<String> capturePath();
}

class CameraLocalDataSourceImpl implements CameraLocalDataSource {
  final ImagePicker picker;
  CameraLocalDataSourceImpl(this.picker);

  @override
  Future<String> capturePath() async {
    throw UnimplementedError('CameraLocalDataSourceImpl.capturePath not implemented');
  }
}
