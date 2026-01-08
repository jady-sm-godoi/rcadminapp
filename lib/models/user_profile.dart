import 'package:rcadminapp/config/app_config.dart';

class UserProfileModel {
  final String email;
  final String imageUrl;
  final DateTime birth;
  final String idCard;
  final String aspect;
  final DateTime aspectDate;
  final String socialName;
  final String gender;
  final String address;
  final String number;
  final String complement;
  final String district;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String phone;
  final String sosContact;
  final String sosPhone;

  UserProfileModel({
    required this.email,
    required this.imageUrl,
    required this.birth,
    required this.idCard,
    required this.aspect,
    required this.aspectDate,
    required this.socialName,
    required this.gender,
    required this.address,
    required this.number,
    required this.complement,
    required this.district,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.phone,
    required this.sosContact,
    required this.sosPhone,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      email: json['email'] ?? '',
      imageUrl: json['image_url'] != null
          ? '${AppConfig.mediaBaseUrl}${json['image_url']}'
          : '',
      birth: DateTime.parse(json['birth']),
      idCard: json['id_card'] ?? '',
      aspect: json['aspect'] ?? '',
      aspectDate: DateTime.parse(json['aspect_date']),
      socialName: json['social_name'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      number: json['number'] ?? '',
      complement: json['complement'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zip_code'] ?? '',
      phone: json['phone'] ?? '',
      sosContact: json['sos_contact'] ?? '',
      sosPhone: json['sos_phone'] ?? '',
    );
  }
}
