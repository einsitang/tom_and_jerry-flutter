import 'package:tom_and_jerry/model/gps_model.dart';

abstract class GpsProvider {
  GpsProvider(String scope);

  String get scope;

  updateScope(String scope);

  Future<GpsModel?> getLatest(String userId);

  Future<List<GpsModel>> listLatest(String userId, {int limit = 10});

  Future<List<GpsModel>> between(
      String userId, DateTime beginTime, DateTime endTime,
      {int limit = 10});

  Future add(GpsModel gpsModel);

  Future addList(List<GpsModel> gpsModels);
}
