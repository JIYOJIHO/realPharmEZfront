import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PharmSearch extends StatefulWidget {
  const PharmSearch({Key? key}) : super(key: key);

  @override
  State<PharmSearch> createState() => _PharmSearchState();
}

class _PharmSearchState extends State<PharmSearch> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final TextEditingController _searchController = TextEditingController();
  final Set<Marker> _markers = {};

  Map<String, dynamic>? _selectedPharmacy; // 선택된 약국 데이터
  bool _isBottomSheetVisible = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(36.3664960, 127.3449815), // 초기 위치
    zoom: 15.0,
  );

  Future<void> _searchPharmacies(String query) async {
    final url = Uri.parse('http://<API_BASE_URL>/api/pharmacies?query=$query'); // Spring Boot API 엔드포인트
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _markers.clear();

      for (var item in data) {
        final LatLng position = LatLng(item['latitude'], item['longitude']);
        _markers.add(
          Marker(
            markerId: MarkerId(item['id'].toString()),
            position: position,
            infoWindow: InfoWindow(title: item['name']),
            onTap: () {
              setState(() {
                _selectedPharmacy = item;
                _isBottomSheetVisible = true;
              });
            },
          ),
        );
      }

      setState(() {}); // UI 업데이트
    } else {
      // 에러 처리
      print('Failed to load pharmacies: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Search'),
      ),
      body: Stack(
        children: [
          // Google Maps
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          // 검색창
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for pharmacies...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  heroTag: "search",
                  mini: true,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _searchPharmacies(_searchController.text);
                  },
                ),
              ],
            ),
          ),
          // 약국 정보 하단 창
          if (_isBottomSheetVisible && _selectedPharmacy != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Card(
                elevation: 8,
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPharmacy!['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${_selectedPharmacy!['address']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phone: ${_selectedPharmacy!['phone']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // 하단 창 닫기
                              setState(() {
                                _isBottomSheetVisible = false;
                                _selectedPharmacy = null;
                              });
                            },
                            child: const Text('Close'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // 다른 동작 추가 (예: 약국으로 길 안내)
                            },
                            child: const Text('Navigate'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
