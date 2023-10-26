import 'package:isar/isar.dart';
import 'package:tom_and_jerry/common/fash_hash.dart';

part 'gps_model.g.dart';

/// GpsModel 记录在用户隔离文件 e.g isar.#userId
@collection
class GpsModel {
  String? id;

  Id get isarId => Tool.fastHash(id!);

  @Index()
  String? userId;

  /// 纬度[latitude]
  double? latitude;

  /// 经度[longitude]
  double? longitude;

  /// 更新时间
  DateTime? updateTime;
}

