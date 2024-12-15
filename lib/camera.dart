import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Remove the second initState() method
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
        );
        await _cameraController.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: _isCameraInitialized
          ? CameraPreview(_cameraController)
          : Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: _isCameraInitialized
          ? FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            final image = await _cameraController.takePicture();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('사진이 저장되었습니다: ${image.path}')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('사진 촬영 실패: $e')),
            );
          }
        },
      )
          : null,
    );
  }
}
