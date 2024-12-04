class Ticker {
  final String status;
  final Data data;

  Ticker({required this.status, required this.data});

  // JSON에서 데이터를 생성하는 팩토리 생성자
  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(
      status: json['status'] as String,
      data: Data.fromJson(json['data']),
    );
  }

  // JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class Data {
  // 필요에 따라 데이터 필드 추가
  // 예를 들어:
  // final String price;

  Data({
// required this.price,
});

factory Data.fromJson(Map<String, dynamic> json) {
return Data(
// price: json['price'] as String,
);
}

Map<String, dynamic> toJson() {
return {
// 'price': price,
};
}
}