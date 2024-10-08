import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vortem_face_detector/vortem_face_detector.dart';



void main() {
  const MethodChannel channel = MethodChannel('vortem_face_detector');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMethodCallHandler(null);
  });

  test('getCameras', () async {
    expect(FaceCamera.cameras, []);
  });
}
