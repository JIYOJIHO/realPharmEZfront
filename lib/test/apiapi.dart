import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part '../apiapi.g.dart';

@RestApi(baseUrl: 'http://apis.data.go.kr/1471000')
abstract class ApiApi {
  factory ApiApi(Dio dio, {String baseUrl}) = _ApiApi;

  @GET("/DrbEasyDrugInfoService/getDrugInfo")
  Future<List<DrugInfo>> getDrugInfo(
      @Query("serviceKey") String serviceKey,
      @Query("itemName") String itemName,
      );
}

@JsonSerializable()
class DrugInfo {
  final String? itemName;
  final String? effect;
  final String? usage;

  DrugInfo({
    this.itemName,
    this.effect,
    this.usage,
  });

  factory DrugInfo.fromJson(Map<String, dynamic> json) => _$DrugInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DrugInfoToJson(this);
}

void main() {
  final dio = Dio(); // Dio 초기화
  final api = ApiApi(dio); // ApiApi 생성

  api.getDrugInfo('your_service_key', '타이레놀').then((response) {
    print(response);
  }).catchError((error) {
    print('Error: $error');
  });
}