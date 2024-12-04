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

  @override
  void initState() {
    super.initState();
    _fetchMedicineInfo(); // 페이지가 처음 로드될 때 약 정보를 가져옵니다.
  }

  // 약 정보를 서버에서 가져오는 함수
  Future<void> _fetchMedicineInfo() async {
    final url = Uri.parse(
        'http://10.0.2.2:8080/medicines?medicineName=${widget.medicineName}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _medicineInfo = data; // 약 정보를 리스트 형태로 저장
          _isLoading = false; // 데이터 로딩 완료
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
  Widget _buildLabeledContent(String title, String? content) {
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
          content ?? '정보 없음',
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
    );
  }
}
