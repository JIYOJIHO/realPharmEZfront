// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiPharm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PharmacyResponse _$PharmacyResponseFromJson(Map<String, dynamic> json) =>
    PharmacyResponse(
      body: json['body'] == null
          ? null
          : PharmacyBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PharmacyResponseToJson(PharmacyResponse instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

PharmacyBody _$PharmacyBodyFromJson(Map<String, dynamic> json) => PharmacyBody(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => DrugInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PharmacyBodyToJson(PharmacyBody instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

DrugInfo _$DrugInfoFromJson(Map<String, dynamic> json) => DrugInfo(
      itemName: json['itemName'] as String?,
      effect: json['effect'] as String?,
      usage: json['usage'] as String?,
    );

Map<String, dynamic> _$DrugInfoToJson(DrugInfo instance) => <String, dynamic>{
      'itemName': instance.itemName,
      'effect': instance.effect,
      'usage': instance.usage,
    };

PharmacyListResponse _$PharmacyListResponseFromJson(
        Map<String, dynamic> json) =>
    PharmacyListResponse(
      body: json['body'] == null
          ? null
          : PharmacyListBody.fromJson(json['body'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PharmacyListResponseToJson(
        PharmacyListResponse instance) =>
    <String, dynamic>{
      'body': instance.body,
    };

PharmacyListBody _$PharmacyListBodyFromJson(Map<String, dynamic> json) =>
    PharmacyListBody(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => PharmacyInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PharmacyListBodyToJson(PharmacyListBody instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

PharmacyInfo _$PharmacyInfoFromJson(Map<String, dynamic> json) => PharmacyInfo(
      pharmacyName: json['pharmacyName'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$PharmacyInfoToJson(PharmacyInfo instance) =>
    <String, dynamic>{
      'pharmacyName': instance.pharmacyName,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ApiPharm implements ApiPharm {
  _ApiPharm(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  }) {
    baseUrl ??= 'http://apis.data.go.kr/B552657';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<PharmacyListResponse> getPharmacyInfo(
    String serviceKey,
    double xPos,
    double yPos,
    int radius,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'serviceKey': serviceKey,
      r'xPos': xPos,
      r'yPos': yPos,
      r'radius': radius,
    };
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<PharmacyListResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/PharmacyService/getPharmacyInfo',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late PharmacyListResponse _value;
    try {
      _value = PharmacyListResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
