import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'InvenCheck.dart';
import 'info.dart'; // info.dart 파일 import
import 'pickup.dart'; // PickUp 페이지를 위해 필요하다면 추가
import 'community.dart'; // 추가한 CommunityScreen 가져오기
import 'camera.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'PharmList.dart';
import 'post.dart';
import 'example_post.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
      routes: {
        '/info': (context) => MedicineInfoPage(), // 약 정보 페이지 라우팅
        '/home': (context) => MapSample(),       // 홈 화면으로 다시 이동
        '/pickup': (context) => PickUpPage(), // PickUp 페이지 추가
        '/mypage': (context) => CameraScreen(),    // 마이페이지 추가
        '/community': (context) => CommunityScreen(), // 커뮤니티 페이지 라우팅 추가
        '/pharm_list': (context) => PharmListPage(), // PharmList 페이지 라우팅 추가
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
  final Completer<GoogleMapController> _controller = Completer<
      GoogleMapController>();
  final PanelController _panelController = PanelController();
  Map<String, dynamic>? _selectedPharmacy;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.5007162693593,	127.036618203089),
    zoom: 16.027,
  );

  // 약국 데이터
  final List<Map<String, dynamic>> _pharmacies = [
    {"name": "대왕약국", "latitude": 36.615853, "longitude": 127.443437},
    {"name": "약국 B", "latitude": 36.3668960, "longitude": 127.3435815},
    {"name": "약국 C", "latitude": 36.3659960, "longitude": 127.3453815},
  ];

  final Set<Marker> _markers = {};
  int _selectedIndex = 0;
  double? lat;
  double? lng;
  Location location = Location();

  final Dio _dio = Dio();
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
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/ad.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                SlidingUpPanel(
                  controller: _panelController,
                  panel: _buildPharmacyInfoPanel(),
                  minHeight: 0,
                  maxHeight: 300,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
                ),
                Positioned(
                  top: 150,
                  right: 16,
                  child: FloatingActionButton(
                    heroTag: "pharm_list_button",
                    onPressed: () {
                      Navigator.pushNamed(context, '/pharm_list');
                    },
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.list, color: Colors.white),
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
                          controller: _searchController,
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
                        onPressed: _searchPharmacies,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            } else if (index == 1) {
              Navigator.pushNamed(context, '/community');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/pickup');
            } else if (index == 3) {
              Navigator.pushNamed(context, '/info');
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
  Widget _buildPharmacyInfoPanel() {
    if (_selectedPharmacy == null) {
      return Center(child: Text('약국 정보를 선택해주세요.'));
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            _selectedPharmacy!['name'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '위치: ${_selectedPharmacy!['latitude']}, ${_selectedPharmacy!['longitude']}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _panelController.close();
                },
                icon: Icon(Icons.close),
                label: Text('닫기'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvenCheckScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.local_shipping),
                label: Text('픽업 예약'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            '기타 정보:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            '약국의 상세 정보를 여기에 추가하세요.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
  Future<void> _currentLocation() async {
    final GoogleMapController controller = await _controller.future;

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

    final currentLocation = await location.getLocation();

    setState(() {
      lat = currentLocation.latitude!;
      lng = currentLocation.longitude!;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(
              currentLocation.latitude!, currentLocation.longitude!),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
    });

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 18.0,
      ),
    ));
  }

  void _searchPharmacies() async {
    final query = _searchController.text.toLowerCase();

    LatLng? firstPharmacyPosition;

    setState(() {
      _markers.clear();

      for (var pharmacy in _pharmacies) {
        if (pharmacy['name'].toLowerCase().contains(query)) {
          final position = LatLng(pharmacy['latitude'], pharmacy['longitude']);
          if (firstPharmacyPosition == null) {
            firstPharmacyPosition = position;
          }
          _markers.add(
            Marker(
              markerId: MarkerId(pharmacy['name']),
              position: position,
              infoWindow: InfoWindow(
                title: pharmacy['name'],
                onTap: () {
                  _showPharmacyInfo(pharmacy);
                },
              ),
            ),
          );
        }
      }
    });

    if (firstPharmacyPosition != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: firstPharmacyPosition!,
          zoom: 18.0,
        ),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색된 약국이 없습니다.')),
      );
    }
  }

  void _showPharmacyInfo(Map<String, dynamic> pharmacy) {
    setState(() {
      _selectedPharmacy = pharmacy;
    });
    _panelController.open(); // SlidingUpPanel 열기
  }
}