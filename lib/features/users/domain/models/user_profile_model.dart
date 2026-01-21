import '../entities/user_profile.dart';
import 'company_model.dart';

class UserProfileModel {
  final String completeName;
  final String maidenName;
  final int age;
  final UserGender gender;
  final String email;
  final String phone;
  final String completeAddress;
  final String university;
  final CompanyModel company;
  final String image;

  const UserProfileModel({
    required this.completeName,
    required this.maidenName,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.completeAddress,
    required this.university,
    required this.company,
    required this.image,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString().trim() ?? '';
    final lastName = json['lastName']?.toString().trim() ?? '';
    final fullName =
        [firstName, lastName].where((part) => part.isNotEmpty).join(' ').trim();
    final maidenName = json['maidenName']?.toString().trim() ?? '';
    final age = (json['age'] is num) ? (json['age'] as num).toInt() : 0;
    final gender = _parseGender(json['gender']?.toString());
    final email = json['email']?.toString().trim() ?? '';
    final phone = json['phone']?.toString().trim() ?? '';
    final university = json['university']?.toString().trim() ?? '';
    final image = json['image']?.toString().trim() ?? '';
    final company = (json['company'] is Map<String, dynamic>)
        ? CompanyModel.fromJson(json['company'] as Map<String, dynamic>)
        : const CompanyModel(
            name: '',
            department: '',
            title: '',
            address: '',
          );
    final address = _buildAddress(json['address'] as Map<String, dynamic>?);

    return UserProfileModel(
      completeName: fullName,
      maidenName: maidenName,
      age: age,
      gender: gender,
      email: email,
      phone: phone,
      completeAddress: address,
      university: university,
      company: company,
      image: image,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      completeName: completeName,
      maidenName: maidenName,
      age: age,
      gender: gender,
      email: email,
      phone: phone,
      completeAddress: completeAddress,
      university: university,
      company: company.toEntity(),
      image: image,
    );
  }

  static UserGender _parseGender(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return UserGender.male;
      case 'female':
        return UserGender.female;
      case 'other':
        return UserGender.other;
      default:
        return UserGender.unknown;
    }
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
