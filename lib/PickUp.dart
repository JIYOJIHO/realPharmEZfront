import 'package:flutter/material.dart';

class PickUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("픽업 내역"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "약, 약국명 검색",
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: Icon(Icons.filter_list, color: Colors.grey),
              ),
            ),
          ),
          // 픽업 내역 리스트
          Expanded(
            child: ListView.builder(
              itemCount: 2, // 내역 개수
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      'lib/assets/tylenol500.png', // 약 이미지 경로
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      "타이레놀 500mg",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("우리들의 약국"),
                        Text("1개, 4,500원"),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // 같은 제품 담기 기능
                        print("같은 제품 담기");
                      },
                      child: Text("같은 제품 담기"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        foregroundColor: Colors.blue[800],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 픽업하러 가기 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print("픽업하러 가기 버튼 클릭");
              },
              child: Text(
                "픽업하러가기",
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue[200],
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
