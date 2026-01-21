import '../entities/company.dart';

class CompanyModel {
  final String name;
  final String department;
  final String title;
  final String address;

  const CompanyModel({
    required this.name,
    required this.department,
    required this.title,
    required this.address,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString().trim() ?? '';
    final department = json['department']?.toString().trim() ?? '';
    final title = json['title']?.toString().trim() ?? '';
    final address = _buildAddress(json['address'] as Map<String, dynamic>?);

    return CompanyModel(
      name: name,
      department: department,
      title: title,
      address: address,
    );
  }

  Company toEntity() {
    return Company(
      name: name,
      department: department,
      title: title,
      address: address,
    );
  }

  static String _buildAddress(Map<String, dynamic>? address) {
    if (address == null) {
      return '';
    }
    final parts = <String>[
      address['address']?.toString().trim() ?? '',
      address['city']?.toString().trim() ?? '',
      address['state']?.toString().trim() ?? '',
      address['country']?.toString().trim() ?? '',
      address['postalCode']?.toString().trim() ?? '',
    ].where((part) => part.isNotEmpty).toList();
    return parts.join(', ');
  }
}
