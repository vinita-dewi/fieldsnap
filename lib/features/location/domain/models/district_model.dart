import '../entities/district.dart';

class DistrictModel {
  final String code;
  final String name;

  const DistrictModel({
    required this.code,
    required this.name,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  District toEntity() {
    return District(
      code: code,
      name: name,
    );
  }
}
