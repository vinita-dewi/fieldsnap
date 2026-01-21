import 'company.dart';

enum UserGender { male, female, other, unknown }

class UserProfile {
  final String completeName;
  final String maidenName;
  final int age;
  final UserGender gender;
  final String email;
  final String phone;
  final String completeAddress;
  final String university;
  final Company company;
  final String image;

  const UserProfile({
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
}
