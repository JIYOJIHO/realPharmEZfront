import 'package:flutter/material.dart';

class InfoPharmPage extends StatefulWidget {
  final String medicineName;

  InfoPharmPage({required this.medicineName});

  @override
  _InfoPharmPageState createState() => _InfoPharmPageState();
}

class _InfoPharmPageState extends State<InfoPharmPage> {
  bool _isInfoSelected = true; // Default tab selection

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
            // 약 이미지 및 설명
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://via.placeholder.com/150', // 약 이미지 URL
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 16),
                Image.network(
                  'https://via.placeholder.com/200x100', // 약 설명 이미지 URL
                  width: 200,
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 약 정보와 보유 약국 버튼
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

            const SizedBox(height: 20),
            // 선택된 콘텐츠 표시
            Expanded(
              child: _isInfoSelected
                  ? _buildMedicineInfo() // 약 정보 화면
                  : _buildPharmacyList(), // 약국 정보 화면
            ),
          ],
        ),
      ),
    );
  }

  // 맞춤 버튼 위젯 생성
  Widget _buildCustomButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF9DBEE3) : Colors.white, // 선택 상태에 따라 배경색 변경
          borderRadius: BorderRadius.circular(12.0), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // 그림자 효과
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey, // 테두리
            width: 1.5,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // 약 정보 화면
  Widget _buildMedicineInfo() {
    return Center(
      child: Text(
        "약 정보: 타이레놀 500mg\n두통 및 발열 완화제",
        style: TextStyle(fontSize: 16, height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }

  // 약국 리스트 화면
  Widget _buildPharmacyList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        _pharmacyTile("베스트힐링약국", "대전 유성구 대학로 611층 (봉명동)", "042-824-9333"),
        _pharmacyTile("유성365약국", "대전 유성구 대학로 44 대림빌딩111,112호", "042-822-5548"),
        _pharmacyTile("우리들의약국", "대전 유성구 공동로18번길311층 (공동)", "042-822-0427"),
        _pharmacyTile("드림약국", "대전 유성구 문화원로 14 (장대동)", "042-822-9831"),
        _pharmacyTile("슬로몬약국", "대전 유성구 문화원로 14 (장대동)", "042-822-9831"),
      ],
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
        isThreeLine: true, // 3줄 표현을 허용
      ),
    );
  }
}
