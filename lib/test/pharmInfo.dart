import 'package:flutter/material.dart';

class PharmInfoScreen extends StatelessWidget {
  final Map<String, dynamic> pharmacy;

  PharmInfoScreen({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pharmacy['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pharmacy['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '위치: ${pharmacy['latitude']}, ${pharmacy['longitude']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '추가 정보는 여기에 표시됩니다.',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              label: Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
