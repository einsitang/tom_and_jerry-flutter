import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:tom_and_jerry/config/app_config.dart';

final Logger log = Logger();

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final AMapFlutterLocation _aMapFlutterLocation = AMapFlutterLocation();

  late final AMapController _controller;

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.setApiKey(
        AppConfig.aMapAndroidAppKey, AppConfig.aMapiOSAppKey);

    // 隐私合规配置
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.updatePrivacyShow(true, true);
  }

  void _moveLocation(Map<String, Object> result) {
    log.d("移动地图到定位点");
    double latitude = double.parse(result["latitude"] as String);
    double longitude = double.parse(result["longitude"] as String);
    log.d("latitude : $latitude , longitude:$longitude");
    _controller?.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude))));
    log.d("移动地图到定位点 done!");
  }

  @override
  Widget build(BuildContext context) {

    onMapCreated(AMapController controller) {
      log.d("amap created / AMapController Assign");
      _controller = controller;
      _aMapFlutterLocation.startLocation();
      _aMapFlutterLocation
          .onLocationChanged()
          .listen((Map<String, Object> result) {
        log.d("_aMapFlutterLocation.onLocationChanged() event");
        log.d(result);
        _moveLocation(result);
      });
    }

    onLocationChanged(AMapLocation location) {
      // 经纬度
      log.d("onLocationChanged");
      LatLng latLng = location.latLng;
      log.d("amap 定位发生改变 经纬: (${latLng.longitude},${latLng.latitude})");
    }

    const AMapPrivacyStatement amapPrivacyStatement =
        AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);

    ///使用默认属性创建一个地图
    final AMapWidget amap = AMapWidget(
      apiKey: const AMapApiKey(
          androidKey: AppConfig.aMapAndroidAppKey,
          iosKey: AppConfig.aMapiOSAppKey),

      ///必须正确设置的合规隐私声明，否则SDK不会工作，会造成地图白屏等问题。
      privacyStatement: amapPrivacyStatement,
      compassEnabled: true,
      onMapCreated: onMapCreated,
      onLocationChanged: onLocationChanged,
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: amap,
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}
