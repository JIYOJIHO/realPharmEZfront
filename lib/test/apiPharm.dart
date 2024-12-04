import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'apiPharm.g.dart';

@RestApi(baseUrl: 'http://apis.data.go.kr/B552657')
abstract class ApiPharm {
  factory ApiPharm(Dio dio, {String baseUrl}) = _ApiPharm;

  @GET("/PharmacyService/getPharmacyInfo")
  Future<PharmacyListResponse> getPharmacyInfo(
      @Query("serviceKey") String serviceKey,
      @Query("xPos") double xPos, // 경도
      @Query("yPos") double yPos, // 위도
      @Query("radius") int radius, // 검색 반경 (미터)
      );
}

@JsonSerializable()
class PharmacyResponse {
  @JsonKey(name: 'body')
  final PharmacyBody? body;

  PharmacyResponse({this.body});

  factory PharmacyResponse.fromJson(Map<String, dynamic> json) =>
      _$PharmacyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyResponseToJson(this);
}

@JsonSerializable()
class PharmacyBody {
  @JsonKey(name: 'items')
  final List<DrugInfo>? items;

  PharmacyBody({this.items});

  factory PharmacyBody.fromJson(Map<String, dynamic> json) =>
      _$PharmacyBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyBodyToJson(this);
}

@JsonSerializable() ///////////수정필요
class DrugInfo {
  @JsonKey(name: 'itemName')
  final String? itemName;
  @JsonKey(name: 'effect')
  final String? effect;
  @JsonKey(name: 'usage')
  final String? usage;

  DrugInfo({
    this.itemName,
    this.effect,
    this.usage,
  });

  factory DrugInfo.fromJson(Map<String, dynamic> json) =>
      _$DrugInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DrugInfoToJson(this);
}

@JsonSerializable()
class PharmacyListResponse {
  @JsonKey(name: 'body')
  final PharmacyListBody? body;

  PharmacyListResponse({this.body});

  factory PharmacyListResponse.fromJson(Map<String, dynamic> json) =>
      _$PharmacyListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyListResponseToJson(this);
}

@JsonSerializable()
class PharmacyListBody {
  @JsonKey(name: 'items')
  final List<PharmacyInfo>? items;

  PharmacyListBody({this.items});

  factory PharmacyListBody.fromJson(Map<String, dynamic> json) =>
      _$PharmacyListBodyFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyListBodyToJson(this);
}

@JsonSerializable()
class PharmacyInfo {
  @JsonKey(name: 'pharmacyName')
  final String? pharmacyName;
  @JsonKey(name: 'address')
  final String? address;
  @JsonKey(name: 'phoneNumber')
  final String? phoneNumber;

  PharmacyInfo({
    this.pharmacyName,
    this.address,
    this.phoneNumber,
  });

  factory PharmacyInfo.fromJson(Map<String, dynamic> json) =>
      _$PharmacyInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyInfoToJson(this);
}

void main() async {
  const String serviceKey = 'your_service_key'; // 서비스 키
  final dio = Dio();
  final api = ApiPharm(dio);

  // 약국 정보 검색 예제
  try {
    final pharmacyResponse = await api.getPharmacyInfo(serviceKey, 126.9784, 37.5665, 1000);
    if (pharmacyResponse.body?.items != null &&
        pharmacyResponse.body!.items!.isNotEmpty) {
      print("근처 약국 검색 결과:");
      for (var pharmacy in pharmacyResponse.body!.items!) {
        print("- 약국 이름: ${pharmacy.pharmacyName}");
        print("  주소: ${pharmacy.address}");
        print("  전화번호: ${pharmacy.phoneNumber}");
        print("");
      }
    } else {
      print("근처 약국 정보를 찾을 수 없습니다.");
    }
  } catch (e) {
    print("약국 검색 오류: $e");
  }
}