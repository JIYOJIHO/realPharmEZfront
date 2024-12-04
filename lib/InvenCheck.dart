import 'package:flutter/material.dart';

class InvenCheckScreen extends StatelessWidget {
  const InvenCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // "메뉴", "정보", "리뷰" 탭
      child: Scaffold(
        appBar: AppBar(
          title: const Text('대왕 약국', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: const [
              Tab(text: '메뉴'),
              Tab(text: '정보'),
              Tab(text: '리뷰'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _menuTab(context),
            Center(child: Text('약국 정보 화면')),
            Center(child: Text('리뷰 화면')),
          ],
        ),
      ),
    );
  }

  Widget _menuTab(BuildContext context) {
    return Column(
      children: [
        // 검색 및 필터 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // 약 찾기 동작
                },
                icon: const Icon(Icons.search, size: 20),
                label: const Text('약 찾기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _filterButton('추천 제품', true),
                      _filterButton('감기약', false),
                      _filterButton('소화기계약', false),
                      _filterButton('해열제', false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // 약품 리스트
        Expanded(
          child: ListView.builder(
            itemCount: pharmacyData.length,
            itemBuilder: (context, index) {
              final product = pharmacyData[index];
              return _productCard(product);
            },
          ),
        ),
      ],
    );
  }

  Widget _filterButton(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          // 필터 동작
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.black : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _productCard(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 약품 이미지
              Image.network(
                product['imageUrl'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
              const SizedBox(width: 16),
              // 약품 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('인기', style: TextStyle(color: Colors.orange)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product['category'],
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product['price']}원',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (product['inStock'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '재고 있음',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              // 재입고 알림 요청 동작
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[100],
                              foregroundColor: Colors.red,
                              elevation: 0,
                            ),
                            child: const Text('재입고 알림 요청'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Mock 데이터
final List<Map<String, dynamic>> pharmacyData = [
  {
    'name': '타이레놀 500밀리그램',
    'category': '진통제',
    'price': 3500,
    'inStock': true,
    'imageUrl': 'https://via.placeholder.com/80',
  },
  {
    'name': '메이킨큐',
    'category': '변비',
    'price': 4500,
    'inStock': false,
    'imageUrl': 'https://via.placeholder.com/80',
  },
  {
    'name': '탁센',
    'category': '진통제',
    'price': 5700,
    'inStock': true,
    'imageUrl': 'https://via.placeholder.com/80',
  },
];
