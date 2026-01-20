import '../entities/province.dart';

class ProvinceModel {
  final String code;
  final String name;

  const ProvinceModel({
    required this.code,
    required this.name,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Province toEntity() {
    return Province(
      code: code,
      name: name,
    );
  }
}
