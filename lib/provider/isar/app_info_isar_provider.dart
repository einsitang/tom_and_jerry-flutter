import 'package:isar/isar.dart';
import 'package:tom_and_jerry/model/app_info_model.dart';
import 'package:tom_and_jerry/provider/app_info_provider.dart';
import 'package:tom_and_jerry/provider/data_provider.dart';

class AppInfoIsarProvider extends DataProvider<Isar>
    implements AppInfoProvider {
  static const String _scope = "global";

  Isar? _isar;

  AppInfoIsarProvider() : super(scope: _scope);

  @override
  Future<AppInfoModel> get appInfo async {
    Isar isar = await db();
    AppInfoModel? appInfoModel =
        isar.appInfoModels.getSync(AppInfoModel.defaultId);
    if (appInfoModel == null) {
      appInfoModel = AppInfoModel();
      await updateAppInfo(appInfoModel);
    }
    return appInfoModel;
  }

  @override
  Future<Isar> db() async {
    _isar = Isar.getInstance("global");
    _isar ??= Isar.openSync([AppInfoModelSchema],
        name: "global", directory: await DataProvider.dir(scope: "global"));

    if (!_isar!.isOpen) {
      _isar!.close();
      _isar = Isar.openSync([AppInfoModelSchema],
          directory: await DataProvider.dir(scope: "global"));
    }
    return _isar!;
  }

  @override
  String get scope => _scope;

  @override
  Future updateAppInfo(AppInfoModel appInfo) async {
    Isar isar = await db();
    await isar.writeTxn(() async {
      await isar.appInfoModels.put(appInfo);
    });
  }

  @override
  updateScope(String scope) {
    // do nothing
  }
}
