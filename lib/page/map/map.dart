import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
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

  bool _keepLocation = false;

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.setApiKey(
        AppConfig.aMapAndroidAppKey, AppConfig.aMapiOSAppKey);

    // 隐私合规配置
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.updatePrivacyShow(true, true);

    /// 动态申请定位权限
    requestPermission();
  }

  void _moveLocation(Map<String, Object> result) {
    log.d("移动地图到定位点");
    if (result['errorCode'] != null) {
      log.d("无法完成地图移动:${result["errorInfo"]}");
      return;
    }

    double latitude = double.tryParse("${result["latitude"]}") ?? double.nan;
    double longitude = double.tryParse("${result["longitude"]}") ?? double.nan;
    if ((latitude.isNaN) || longitude.isNaN) {
      return;
    }
    log.d("latitude : $latitude , longitude:$longitude");
    _controller.moveCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15)));
    log.d("移动地图到定位点 done!");
  }

  void _startLocation(){
    Future.delayed(const Duration(seconds:2),(){
      _aMapFlutterLocation.startLocation();
      log.d("开始定位...");
    });
  }

  void _stopLocation(){
    if(_keepLocation){
      return ;
    }
    Future.delayed(const Duration(seconds:2),(){
      _aMapFlutterLocation.stopLocation();
      log.d("停止定位");
    });
  }

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      log.d("定位权限申请通过");
    } else {
      log.d("定位权限申请不通过");
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    onMapCreated(AMapController controller)  {
      log.d("amap created / AMapController Assign");
      _controller = controller;

      requestPermission();
      // _startLocation();

      _aMapFlutterLocation
          .onLocationChanged()
          .listen((Map<String, Object> result) {
        log.d("_aMapFlutterLocation.onLocationChanged() event");
        _moveLocation(result);

        _stopLocation();
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
  void dispose() {
    _aMapFlutterLocation.stopLocation();
    super.dispose();
  }
}
