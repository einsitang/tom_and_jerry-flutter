import 'package:tom_and_jerry/model/app_info_model.dart';

abstract class AppInfoProvider {

  Future<AppInfoModel> get appInfo;
  Future updateAppInfo(AppInfoModel appInfo);

}
