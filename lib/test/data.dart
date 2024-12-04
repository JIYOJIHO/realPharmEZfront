class MedicineData {
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

  // 오류 메시지
  final String message;

  // 생성자
  MedicineData({
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

  // JSON에서 데이터를 생성하는 팩토리 생성자
  factory MedicineData.fromJson(Map<String, dynamic> json) {
    return MedicineData(
      pharmaceuticalCompany: json['pharmaceuticalCompany'] as String,
      medicineName: json['medicineName'] as String,
      efficacy: json['efficacy'] as String,
      medicineUse: json['medicineUse'] as String,
      precautionWarn: json['precautionWarn'] as String,
      usingPrecaution: json['usingPrecaution'] as String,
      medicineInteractions: json['medicineInteractions'] as String,
      medicineSideEffect: json['medicineSideEffect'] as String,
      storage: json['storage'] as String,
      image: json['image'] as String,
      message: json['message'] as String,
    );
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'pharmaceuticalCompany': pharmaceuticalCompany,
      'medicineName': medicineName,
      'efficacy': efficacy,
      'medicineUse': medicineUse,
      'precautionWarn': precautionWarn,
      'usingPrecaution': usingPrecaution,
      'medicineInteractions': medicineInteractions,
      'medicineSideEffect': medicineSideEffect,
      'storage': storage,
      'image': image,
      'message': message,
    };
  }
}
