import '../entities/regency.dart';

class RegencyModel {
  final String code;
  final String name;

  const RegencyModel({
    required this.code,
    required this.name,
  });

  factory RegencyModel.fromJson(Map<String, dynamic> json) {
    return RegencyModel(
      code: (json['code'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  Regency toEntity() {
    return Regency(
      code: code,
      name: name,
    );
  }
}
