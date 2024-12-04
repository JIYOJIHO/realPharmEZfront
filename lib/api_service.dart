import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'medicine.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // 엔드포인트에서 데이터를 가져오는 메서드
  Future<Medicine> getMedicineById(String id) async {
    try {
      final response = await _dio.get('http://localhost:8080/medicines/$id');
      if (response.statusCode == 200) {
        return Medicine.fromJson(response.data); // JSON 데이터를 객체로 변환
      } else {
        throw Exception("Failed to load medicine data");
      }
    } catch (e) {
      throw Exception("Failed to load medicine data: $e");
    }
  }
}