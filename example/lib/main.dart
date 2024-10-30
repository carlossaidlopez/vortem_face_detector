import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vortem_face_detector/vortem_face_detector.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FaceCamera.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  final Color primeyColor = const Color(0xFF00BFA5);
  final Color secondaryColor = const Color(0xFFFFFFFF);
  final Color tertiaryColor = const Color(0xFF00BFA5);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _capturedImage;

  late FaceCameraController controller;

  @override
  void initState() {
    controller = 
    FaceCameraController(
            autoCapture: false,
            defaultFlashMode: 
                 CameraFlashMode.auto,
            defaultCameraLens: CameraLens.back,
            onCapture: (File? image) {
              setState(() => _capturedImage = image);
            },
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('FaceCamera example app'),
          ),
          body: Builder(builder: (context) {
            if (_capturedImage != null) {
              return Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.file(
                      _capturedImage!,
                      width: double.maxFinite,
                      fit: BoxFit.fitWidth,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await controller.startImageStream();
                          setState(() => _capturedImage = null);
                        },
                        child: const Text(
                          'Capture Again',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ))
                  ],
                ),
              );
            }
            return SmartFaceCamera(
                          controller: controller,
                          fixedAspectRatio: BoxFit.cover,
                          backgroundControllersDecoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(10)),
                          backgroundControllersPadding: const EdgeInsets.all(2),
                          flashControlBuilder: (context, mode) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.tertiaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                mode == CameraFlashMode.auto
                                    ? Icons.flash_auto
                                    : mode == CameraFlashMode.always
                                        ? Icons.flash_on
                                        : Icons.flash_off,
                                color: widget.secondaryColor,
                                size: 25,
                              ),
                            );
                          },
                          captureControlBuilder: (context, detectedFace) {
                            final face = detectedFace?.face;
                            return Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: widget.tertiaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: face == null
                                  ? Icon(
                                      Icons.camera_alt,
                                      color: widget.secondaryColor
                                          .withOpacity(0.6),
                                      size: 70,
                                    )
                                  : Icon(
                                      Icons.camera_alt,
                                      color: widget.secondaryColor,
                                      size: 70,
                                    ),
                            );
                          },
                          lensControlIcon: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.tertiaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flip_camera_ios,
                              color: widget.secondaryColor,
                              size: 30,
                            ),
                          ),
                          indicatorBuilder: (context, detectedFace, imageSize) {
                            if (detectedFace == null) {
                              return Container();
                            }
                            if (detectedFace.face == null) {
                              return Container();
                            }
                            final face = detectedFace.face!;
                            final faceRect = face.boundingBox;
                            final faceCenter = Offset(
                              faceRect.left + faceRect.width / 2,
                              faceRect.top + faceRect.height / 2,
                            );
                            final faceRadius =
                                min(faceRect.width, faceRect.height) / 2;
                            return CustomPaint(
                              painter: FaceIndicatorPainter(
                                faceCenter: faceCenter,
                                faceRadius: faceRadius,
                                imageSize: imageSize ?? const Size(50, 50),
                                color: widget.primeyColor,
                              ),
                            );
                          },
                          message: 'Centrar el rostro',
                          autoDisableCaptureControl: true,
                          messageStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          messageBuilder: (context, detectedFace) {
                            Widget message;
                            if (detectedFace == null) {
                              message = Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Rostro no encontrado',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            } else {
                              if (detectedFace.face != null) {
                                message = Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Centre el rostro',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              } else {
                                message = Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'Rostro no encontrado',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              }
                            }
                            return Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: message,
                                ));
                          });
          })),
    );
  }
  

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
class FaceIndicatorPainter extends CustomPainter {
  final Offset faceCenter;
  final double faceRadius;
  final Size imageSize;
  final Color color;

  FaceIndicatorPainter({
    required this.faceCenter,
    required this.faceRadius,
    required this.imageSize,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    final adjustedCenter = Offset(
      faceCenter.dx * scaleX,
      faceCenter.dy * scaleY,
    );

    final adjustedRadiusX = faceRadius * scaleX;
    final adjustedRadiusY = faceRadius * scaleY;

    canvas.drawOval(
      Rect.fromCenter(
        center: adjustedCenter,
        width: adjustedRadiusX * 1.5,
        height: adjustedRadiusY * 2,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(FaceIndicatorPainter oldDelegate) {
    return faceCenter != oldDelegate.faceCenter ||
        faceRadius != oldDelegate.faceRadius ||
        imageSize != oldDelegate.imageSize ||
        color != oldDelegate.color;
  }
}
