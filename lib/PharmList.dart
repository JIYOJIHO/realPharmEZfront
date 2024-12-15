import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PharmListPage extends StatefulWidget {
  @override
  _PharmListPageState createState() => _PharmListPageState();
}

class _PharmListPageState extends State<PharmListPage> {
  final String apiUrl = 'http://10.0.2.2:8080/pharmacies?latitude=37.62028021&longitude=127.017573969681';
  final Dio _dio = Dio();

  List<dynamic> _pharmacies = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPharmacies();
  }

  Future<void> _fetchPharmacies() async {
    try {
      final response = await _dio.get(apiUrl);
      setState(() {
        _pharmacies = response.data;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = '약국 정보를 불러오는 데 실패했습니다.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('약국 리스트'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _buildPharmacyList(),
    );
  }

  Widget _buildPharmacyList() {
    return ListView.builder(
      itemCount: _pharmacies.length,
      itemBuilder: (context, index) {
        final pharmacy = _pharmacies[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: pharmacy['imageUrl'] != null
                ? Image.network(
              pharmacy['imageUrl'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            )
                : Icon(
              Icons.local_pharmacy,
              size: 60,
              color: Colors.green,
            ),
            title: Text(pharmacy['name'] ?? '알 수 없는 약국'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pharmacy['address'] ?? '주소 정보 없음'),
                SizedBox(height: 4),
                Text('${pharmacy['distance']?.toStringAsFixed(2) ?? '??'} km'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // 예약 또는 상세보기 기능 구현 가능
              },
              child: Text('픽업 예약'),
            ),
          ),
        );
      },
    );
  }
}
