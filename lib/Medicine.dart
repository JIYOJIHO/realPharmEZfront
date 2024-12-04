import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Medicine {
  final String pharmaceuticalCompany;
  final String medicineName;
  final String efficacy;
  final String medicineUse;
  final String precautionWarn;
  final String usingPrecaution;
  final String medicineInteractions;
  final String medicineSideEffect;
  final String storage;
  final String image;
  final String message;

  Medicine({
    required this.pharmaceuticalCompany,
    required this.medicineName,
    required this.efficacy,
    required this.medicineUse,
    required this.precautionWarn,
    required this.usingPrecaution,
    required this.medicineInteractions,
    required this.medicineSideEffect,
    required this.storage,
    required this.image,
    required this.message,
  });

  // JSON을 객체로 변환하는 factory 메서드
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      pharmaceuticalCompany: json['pharmaceuticalCompany'] ?? '',
      medicineName: json['medicineName'] ?? '',
      efficacy: json['efficacy'] ?? '',
      medicineUse: json['medicineUse'] ?? '',
      precautionWarn: json['precautionWarn'] ?? '',
      usingPrecaution: json['usingPrecaution'] ?? '',
      medicineInteractions: json['medicineInteractions'] ?? '',
      medicineSideEffect: json['medicineSideEffect'] ?? '',
      storage: json['storage'] ?? '',
      image: json['image'] ?? '',
      message: json['message'] ?? '',
    );
  }
}