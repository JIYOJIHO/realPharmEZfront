import 'package:flutter/material.dart';
import 'InfoPharm.dart'; // Import the new page for drug information

class MedicineInfoPage extends StatefulWidget {
  @override
  _MedicineInfoPageState createState() => _MedicineInfoPageState();
}

class _MedicineInfoPageState extends State<MedicineInfoPage> {
  TextEditingController _controller = TextEditingController(); // 텍스트 필드 컨트롤러
  String _searchQuery = ''; // 검색어

  // 검색 결과를 처리하는 함수
  void _searchMedicine() {
    setState(() {
      _searchQuery = _controller.text; // 사용자가 입력한 검색어 저장
    });
    // TODO: 실제 약 정보 검색 로직 추가
    print('Searching for: $_searchQuery');
    // Navigate to InfoPharmPage with the search query
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPharmPage(medicineName: _searchQuery),
      ),
    );
  }

  // 위치 정보를 얻는 함수
  void _currentLocation() {
    // TODO: 위치 정보를 얻는 로직 추가
    print('Current location button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0x9DBEE3FF),
        title: Text("약 정보", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // Positioned 위젯을 위한 간격
                _searchQuery.isNotEmpty
                    ? Expanded(
                  child: Center(
                    child: Text(
                      '검색한 약: $_searchQuery',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                )
                    : Center(
                  child: Text(
                    '검색 결과가 없습니다.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: "current_location",
                  onPressed: _currentLocation,
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(Icons.my_location, color: Colors.black),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '약 이름을 검색하세요...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search, color: Color(0x9DBEE3FF)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: "search_button",
                  onPressed: _searchMedicine,
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(Icons.search, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
