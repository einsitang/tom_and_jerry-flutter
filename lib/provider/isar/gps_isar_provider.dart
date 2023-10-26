import 'package:isar/isar.dart';
import 'package:tom_and_jerry/model/gps_model.dart';
import 'package:tom_and_jerry/provider/data_provider.dart';
import 'package:tom_and_jerry/provider/gps_provider.dart';

class GpsIsarProvider extends DataProvider<Isar> implements GpsProvider {
  String _scope;

  Isar? _isar;

  GpsIsarProvider(this._scope) : super(scope:_scope);

  @override
  String get scope => _scope;

  @override
  updateScope(String scope) {
    _scope = scope;
  }

  @override
  Future<Isar> db() async {
    _isar = Isar.getInstance(_scope);
    _isar ??= Isar.openSync([GpsModelSchema],name:_scope, directory: await DataProvider.dir(scope: _scope));

    if (!_isar!.isOpen) {
      _isar!.close();
      _isar = Isar.openSync([GpsModelSchema],
          directory: await DataProvider.dir(scope: _scope));
    }
    return _isar!;
  }

  @override
  Future<List<GpsModel>> between(
      String userId, DateTime beginTime, DateTime endTime,
      {int limit = 10}) async {
    Isar isar = await db();
    return isar.gpsModels
        .filter()
        .userIdEqualTo(userId)
        .updateTimeBetween(beginTime, endTime)
        .sortByUpdateTimeDesc()
        .findAllSync();
  }

  @override
  Future<GpsModel?> getLatest(String userId) async {
    Isar isar = await db();
    return isar.gpsModels
        .filter()
        .userIdEqualTo(userId)
        .sortByUpdateTimeDesc()
        .findFirstSync();
  }

  @override
  Future<List<GpsModel>> listLatest(String userId, {int limit = 10}) async {
    Isar isar = await db();
    limit = _range(limit, 1, 20);
    return isar.gpsModels
        .filter()
        .userIdEqualTo(userId)
        .sortByUpdateTimeDesc()
        .limit(limit)
        .findAllSync();
  }

  @override
  Future add(GpsModel gpsModel) async {
    Isar isar = await db();
    await isar.gpsModels.put(gpsModel);
  }

  @override
  Future addList(List<GpsModel> gpsModels) async {
    Isar isar = await db();
    await isar.gpsModels.putAll(gpsModels);
  }

  _range(int num, int lower, int upper) {
    if (num < lower) {
      num = 1;
    }
    if (num > upper) {
      num = upper;
    }
    return num;
  }
}
