#import "VortemFaceDetectorPlugin.h"
#if __has_include(<vortem_face_detector/vortem_face_detector-Swift.h>)
#import <vortem_face_detector/vortem_face_detector-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vortem_face_detector-Swift.h"
#endif

@implementation VortemFaceDetectorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVortemFaceDetectorPlugin registerWithRegistrar:registrar];
}
@end
