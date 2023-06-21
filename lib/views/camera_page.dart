import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// late List<CameraDescription> _cameras = await avaliableCameras();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   _cameras = await availableCameras();
//   runApp(const CameraApp());
// }

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  final _textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.nv21);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  scanImage() async {
    final navigator = Navigator.of(context);

    try {
      final pictureFile = await controller.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      navigator.pushReplacementNamed('/calculo',
          arguments: recognizedText.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Um erro ocorreu enquanto escaneava o texto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          color: Colors.black,
          child: Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(controller),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      scanImage();
                    },
                    child: const Icon(Icons.camera),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
