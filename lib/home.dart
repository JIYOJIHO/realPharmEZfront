import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'InvenCheck.dart';
import 'info.dart'; // info.dart 파일 import
import 'pickup.dart'; // PickUp 페이지를 위해 필요하다면 추가
// import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
      routes: {
        '/info': (context) => MedicineInfoPage(), // 약 정보 페이지 라우팅
        '/home': (context) => MapSample(), // 홈 화면으로 다시 이동
        '/pickup': (context) => InvenCheckScreen(), // PickUp 페이지 추가 (필요 시)
        '/mypage': (context) => PickUpPage()
      },
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.3664960, 127.3449815),
    zoom: 16.027,
  );

  final Set<Marker> _markers = {};
  int _selectedIndex = 0;
  double? lat;
  double? lng;
  Location location = Location();

  // API 통신을 위한 Dio와 ApiApi 객체
  final Dio _dio = Dio();

  // 검색어 및 API 결과 상태
  final TextEditingController _searchController = TextEditingController();
  String _drugInfo = ''; // 약 정보 표시 상태

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 상단 광고 이미지
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/ad.png'), // 광고 이미지 경로
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 지도
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: _markers, // 마커 추가
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                // 검색창과 현재 위치 버튼
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
                          decoration: InputDecoration(
                            hintText: 'Search location...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton(
                        heroTag: "search_button",
                        onPressed: () {
                          // 간단한 검색 버튼 동작
                          print('Search button clicked!');
                        },
                        backgroundColor: Colors.white,
                        mini: true,
                        child: Icon(Icons.search, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // 하단 네비게이션 바
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/info'); // 약 정보 페이지
            } else if (index == 2) {
              Navigator.pushNamed(context, '/pickup'); // 픽업 페이지
            } else if (index == 4) {
              Navigator.pushNamed(context, '/mypage');
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: '픽업',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information),
            label: '약 정보',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }

  Future<void> _currentLocation() async {
    final GoogleMapController controller = await _controller.future;

    // 위치 권한 확인 및 요청
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // 현재 위치 가져오기
    final currentLocation = await location.getLocation();

    // 마커 업데이트
    setState(() {
      lat = currentLocation.latitude!;
      lng = currentLocation.longitude!;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    });

    // 카메라를 현재 위치로 이동
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 18.0,
      ),
    ));
  }
}
