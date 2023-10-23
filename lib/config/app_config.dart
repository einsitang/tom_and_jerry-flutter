// lib/env/env.dart
import 'package:envied/envied.dart';

part 'app_config.g.dart';

@Envied(path : '.env')
abstract class AppConfig{
  // NIM APP KEY
  @EnviedField(varName: "NIM_APPKEY")
  static const String nIMAppKey = _AppConfig.nIMAppKey;

  // AMap iOS APP KEY
  @EnviedField(varName: "AMAP_IOS_APPKEY")
  static const String aMapiOSAppKey = _AppConfig.aMapiOSAppKey;

  // AMap Android APP KEY
  @EnviedField(varName: "AMAP_ANDROID_APPKEY")
  static const String aMapAndroidAppKey = _AppConfig.aMapAndroidAppKey;
}
