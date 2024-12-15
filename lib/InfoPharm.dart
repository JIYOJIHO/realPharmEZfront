import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoPharmPage extends StatefulWidget {
  final String medicineName;

  InfoPharmPage({required this.medicineName});

  @override
  _InfoPharmPageState createState() => _InfoPharmPageState();
}

class _InfoPharmPageState extends State<InfoPharmPage> {
  bool _isInfoSelected = true; // Default tab selection
  bool _isLoading = true; // 데이터 로딩 여부
  List<dynamic>? _medicineInfo; // 약 정보 저장
  List<PharmacyInfoResponse>? _pharmacyList; // 약국 정보 저장 리스트


  @override
  void initState() {
    super.initState();
    _fetchMedicineInfo(); // 약 정보 가져오기
    _fetchPharmacyInfo(); // 약국 정보 가져오기
  }

  // 약국 정보를 서버에서 가져오는 함수
  Future<void> _fetchPharmacyInfo() async {
    final latitude = 37.5007162693593; // 예시 위도
    final longitude = 127.036618203089; // 예시 경도
    final url = Uri.parse(
        'http://10.0.2.2:8080/stocks/search/${widget.medicineName}?latitude=$latitude&longitude=$longitude&page=0&size=10');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        print('Pharmacy Data: $data'); // 디버깅용 출력
        setState(() {
          _pharmacyList = data.map((item) {
            return PharmacyInfoResponse.fromJson(item);
          }).toList();
          // 중복 제거 (약국 이름을 기준으로 필터링)
          _pharmacyList = _pharmacyList!.toSet().toList();
        });
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        throw Exception('약국 정보를 불러오는 데 실패했습니다.');
      }
    } catch (error) {
      print('Error fetching pharmacy info: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMedicineInfo() async {
    final url = Uri.parse('http://10.0.2.2:8080/medicines/195900034');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          if (data is Map<String, dynamic>) {
            _medicineInfo = [data]; // 단일 객체를 리스트로 감싸기
          } else if (data is List) {
            _medicineInfo = data;
          } else {
            throw Exception("Unexpected data format");
          }
          _isLoading = false; // 로딩 상태 종료
        });
      } else {
        throw Exception('약 정보를 불러오는 데 실패했습니다.');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching medicine info: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9DBEE3),
        title: Text(
          widget.medicineName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 약 이미지
            _isLoading
                ? CircularProgressIndicator()
                : Center(
              child: Image.network(
                _medicineInfo != null && _medicineInfo!.isNotEmpty
                    ? _medicineInfo![0]['image'] ?? 'https://via.placeholder.com/120'
                    : 'https://via.placeholder.com/120',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 120);
                },
              ),
            ),
            const SizedBox(height: 16),
            // 약 정보 및 약국 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isInfoSelected = true;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "약 정보",
                        style: TextStyle(
                          fontWeight: _isInfoSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 100,
                        color: _isInfoSelected ? Colors.blue : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isInfoSelected = false;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        "보유 약국",
                        style: TextStyle(
                          fontWeight: !_isInfoSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 100,
                        color: !_isInfoSelected ? Colors.blue : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 선택된 콘텐츠 표시
            Expanded(
              child: _isInfoSelected
                  ? _buildMedicineInfo() // 약 정보 화면
                  : _buildPharmacyList(), // 약국 리스트 화면
            ),
          ],
        ),
      ),
    );
  }

  // 약 정보 화면
  Widget _buildMedicineInfo() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (_medicineInfo == null || _medicineInfo!.isEmpty) {
      return Center(child: Text('약 정보가 없습니다.'));
    }

    final medicine = _medicineInfo![0];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLabeledContent("약 이름", medicine['medicineName']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("제약 회사", medicine['pharmaceuticalCompany']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("효능", medicine['efficacy']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("사용법", medicine['medicineUse']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("주의사항 경고", medicine['precautionWarn']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("사용 주의사항", medicine['usingPrecaution']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("약물 상호작용", medicine['medicineInteractions']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("부작용", medicine['medicineSideEffect']),
              const Divider(color: Colors.grey, thickness: 0.5, height: 24),
              _buildLabeledContent("보관법", medicine['storage']),
            ],
          ),
        ),
      ),
    );
  }

  // 제목과 내용을 한 줄로 표시하는 위젯
  Widget _buildLabeledContent(String title, dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content?.toString() ?? '정보 없음',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // 약국 리스트 화면
  Widget _buildPharmacyList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_pharmacyList == null || _pharmacyList!.isEmpty) {
      return Center(child: Text('보유 약국 정보가 없습니다.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: _pharmacyList!.length,
      itemBuilder: (context, index) {
        final pharmacy = _pharmacyList![index];
        return _pharmacyTile(
          pharmacy.name ?? '알 수 없는 이름',
          pharmacy.address ?? '알 수 없는 주소',
          pharmacy.tel ?? '알 수 없는 전화번호',
        );
      },
    );
  }

  // 약 정보를 표시하는 텍스트 행 생성 함수
  Widget _buildTextRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: ${value ?? '정보 없음'}",
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _pharmacyTile(String name, String address, String phone) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("$address\n$phone"),
        ),
        trailing: Text(
          "재고 보유 중",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        isThreeLine: true,
      ),
    );
  }
}
class PharmacyInfoResponse {
  final String? address;
  final String? name;
  final String? tel;
  final double? distance;
  final String? message;

  PharmacyInfoResponse({this.address, this.name, this.tel, this.distance, this.message});

  factory PharmacyInfoResponse.fromJson(Map<String, dynamic> json) {
    return PharmacyInfoResponse(
      address: json['address'],
      name: json['name'],
      tel: json['tel'],
      distance: json['distance'],
      message: json['message'],
    );
  }

  // 중복 제거를 위한 hashCode와 == 연산자 재정의
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PharmacyInfoResponse &&
        other.name == name &&
        other.address == address;
  }

  @override
  int get hashCode => (name ?? '').hashCode ^ (address ?? '').hashCode;
}


/*
  // 약국 리스트 화면
  Widget _buildPharmacyList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        _pharmacyTile("베스트힐링약국", "대전 유성구 대학로 61", "042-824-9333"),
        _pharmacyTile("유성365약국", "대전 유성구 대학로 44", "042-822-5548"),
        _pharmacyTile("우리들의약국", "대전 유성구 공동로18번길", "042-822-0427"),
        _pharmacyTile("드림약국", "대전 유성구 문화원로 14", "042-822-9831"),
        _pharmacyTile("슬로몬약국", "대전 유성구 문화원로 14", "042-822-9831"),
      ],
    );
  }

  // 약 정보를 표시하는 텍스트 행 생성 함수
  Widget _buildTextRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: ${value ?? '정보 없음'}",
        style: TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  // 약국 정보를 표시하는 ListTile 생성 함수
  Widget _pharmacyTile(String name, String address, String phone) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text("$address\n$phone"),
        ),
        trailing: Text(
          "재고 보유 중",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        isThreeLine: true,
      ),
    );*/
