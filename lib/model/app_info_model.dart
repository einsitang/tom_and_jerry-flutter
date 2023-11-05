import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:tom_and_jerry/config/app_config.dart';

part "app_info_model.g.dart";

/// 应用信息 记录在全局 e.g : isar.global
@collection
class AppInfoModel {
  @Ignore()
  static const int defaultId = 1;

  /// 数据版本,固定为 [defaultId]
  Id id = defaultId;

  /// 平台 iOS | Android
  String? platform;

  /// 平台版本 e.g : Android 8.1.0
  String? platformVersion;

  /// 软件版本
  String get appVersion => AppConfig.version;

  /// 安装时间
  DateTime? installTime;

  /// 用户配置信息 仅当已授权后获取 loginAuth not null
  UserProfile? _userProfile;

  UserProfile get userProfile => _userProfile ?? UserProfile();

  set userProfile(UserProfile userProfile) {
    _userProfile = userProfile;
  }

  /// 登录认证信息
  LoginAuth loginAuth = LoginAuth();
}

@embedded
class UserProfile {
  String? id;

  /// 账号
  String? account;

  /// 名称
  String? name;

  /// 头像
  String? avatar;

  /// 最后记录的 纬度[latitude]
  double? latestLatitude;

  /// 最后记录的 经度[longitude]
  double? latestLongitude;

  /// 最后更新的GPS时间
  DateTime? latestGpsTime;

  /// 注册时间
  DateTime? registerTime;

  /// 个人信息更新时间
  DateTime? updateTime;

  @enumerated
  ThemeMode themeMode = ThemeMode.system;
}

@embedded
class LoginAuth {
  String? userId;

  String? account;

  // 检查是否登录
  bool get isLogin => accessToken != null;

  /// accessToken 用于请求凭证
  String? accessToken;

  /// refreshToken 用于快过期时更换接口用
  String? refreshToken;

  /// 登录时间
  DateTime? loginTime;

  /// 认证过期时间
  DateTime? expireTime;
}
