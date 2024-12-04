import 'package:flutter/material.dart';
import 'dart:convert'; // JSON 처리
import 'package:http/http.dart' as http;
import 'infoPharm.dart'; // InfoPharmPage를 추가하세요

class SearchResultPage extends StatefulWidget {
  final String medicineName;

  SearchResultPage({required this.medicineName});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  TextEditingController _searchController = TextEditingController();
  late String _currentSearchQuery;

  @override
  void initState() {
    super.initState();
    _currentSearchQuery = widget.medicineName; // 초기 검색어
    _searchController.text = widget.medicineName;
  }

  Future<List<dynamic>> fetchMedicineInfo(String name) async {
    final url = Uri.parse('http://10.0.2.2:8080/medicines?medicineName=$name');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body); // 약물 데이터 리스트 반환
      } catch (e) {
        throw Exception('JSON 파싱 오류: $e');
      }
    } else {
      throw Exception('데이터 로드 실패: ${response.statusCode}');
    }
  }

  void _performSearch() {
    setState(() {
      _currentSearchQuery = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '검색 결과',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '약 이름을 입력하세요...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _performSearch,
                  backgroundColor: Colors.white,
                  mini: true,
                  child: Icon(Icons.search, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchMedicineInfo(_currentSearchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      '검색 결과가 없습니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // 검색 결과를 표시
                final medicines = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    return GestureDetector(
                      onTap: () {
                        // 카드 클릭 시 InfoPharmPage로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                InfoPharmPage(medicineName: medicine['medicineName']),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      medicine['medicineName'] ?? '알 수 없는 약',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '제약사: ${medicine['pharmaceuticalCompany'] ?? '정보 없음'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '효능: ${medicine['efficacy'] ?? '효능 정보 없음'}',
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                              if (medicine['image'] != null)
                                Container(
                                  width: 100,
                                  height: 100,
                                  margin: EdgeInsets.only(left: 16),
                                  child: Image.network(
                                    medicine['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
