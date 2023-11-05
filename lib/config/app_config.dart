// lib/env/env.dart
import 'package:envied/envied.dart';

part 'app_config.g.dart';

@Envied(path: '.env')
abstract class AppConfig {
  // NIM APP KEY
  @EnviedField(varName: "NIM_APPKEY")
  static const String nIMAppKey = _AppConfig.nIMAppKey;

  // AMap iOS APP KEY
  @EnviedField(varName: "AMAP_IOS_APPKEY")
  static const String aMapiOSAppKey = _AppConfig.aMapiOSAppKey;

  // AMap Android APP KEY
  @EnviedField(varName: "AMAP_ANDROID_APPKEY")
  static const String aMapAndroidAppKey = _AppConfig.aMapAndroidAppKey;

  /// 应用版本,如果不定义则默认 1.0.0
  @EnviedField(defaultValue: "1.0.0", varName: "APP_VERSION")
  static const String version = _AppConfig.version;
}
