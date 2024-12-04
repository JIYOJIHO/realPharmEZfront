import 'package:dio/dio.dart';
import 'Medicine.dart';

class ApiClient {
  final Dio _dio = Dio();
  final String _baseUrl = "http://localhost:8080"; // 서버 URL (로컬 환경 기준)

  // 약 정보를 가져오는 함수
  Future<Medicine> fetchMedicine(String medicineId) async {
    try {
      final response = await _dio.get('$_baseUrl/medicines/$medicineId');
      if (response.statusCode == 200) {
        return Medicine.fromJson(response.data); // 데이터가 정상적이면 Medicine 객체로 변환
      } else {
        throw Exception('Failed to load medicine data');
      }
    } catch (e) {
      throw Exception('Error fetching medicine: $e');
    }
  }
}
