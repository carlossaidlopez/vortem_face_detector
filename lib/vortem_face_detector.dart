import 'dart:async';

import 'package:camera/camera.dart';

import 'src/utils/logger.dart';

export 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

export 'package:vortem_face_detector/src/smart_face_camera.dart';
export 'package:vortem_face_detector/src/res/enums.dart';
export 'package:vortem_face_detector/src/models/detected_image.dart';
export 'package:vortem_face_detector/src/controllers/face_camera_controller.dart';

class FaceCamera {
  static List<CameraDescription> _cameras = [];

  /// Initialize device cameras
  static Future<void> initialize() async {
    /// Fetch the available cameras before initializing the app.
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
  }

  /// Returns available cameras
  static List<CameraDescription> get cameras {
    return _cameras;
  }
}
