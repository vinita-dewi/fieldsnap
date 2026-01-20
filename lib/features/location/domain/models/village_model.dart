import '../entities/village.dart';

class VillageModel {
  final String code;
  final String name;

  const VillageModel({
    required this.code,
    required this.name,
  });

  factory VillageModel.fromJson(Map<String, dynamic> json) {
    return VillageModel(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Village toEntity() {
    return Village(
      code: code,
      name: name,
    );
  }
}
