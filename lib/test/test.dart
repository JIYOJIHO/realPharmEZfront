import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  // 코인 데이터를 가져오는 함수
  Future<Ticker> getCoinTicker(String orderCurrency, String paymentCurrency) async {
    final response = await _dio.get(
      "public/ticker/$orderCurrency\_$paymentCurrency",
    );

    if (response.statusCode == 200) {
      return Ticker.fromJson(response.data);
    } else {
      throw Exception("Failed to load data");
    }
  }
}
