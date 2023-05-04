import 'package:permission_handler/permission_handler.dart';

class HandlePermissions {
  Future<bool> checkNotificationPermission() async {
    bool status = await Permission.notification.isGranted;
    if (!status) {
      await Permission.notification.request();
      return await Permission.notification.status.isGranted;
    } else {
      return true;
    }
  }

  static Future<bool> checkCameraPermission() async {
    bool status = await Permission.camera.request().isGranted;
    return !status ? await Permission.camera.request().isGranted : true;
  }

  static Future<bool> checkGalleryPermission() async {
    bool status = await Permission.storage.isGranted;
    if (!status) {
      await Permission.camera.request();
      return await Permission.storage.status.isGranted;
    } else {
      return true;
    }
  }
}
