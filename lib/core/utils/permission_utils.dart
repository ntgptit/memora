import 'package:memora/core/services/permission_service.dart';

abstract final class PermissionUtils {
  static bool isGranted(PermissionState state) {
    return state == PermissionState.granted || state == PermissionState.limited;
  }

  static bool requiresManualEnable(PermissionState state) {
    return state == PermissionState.permanentlyDenied;
  }
}
