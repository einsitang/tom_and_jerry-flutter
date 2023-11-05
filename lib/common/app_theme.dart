import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/model/app_info_model.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

class AppTheme {
  static ThemeData get dark => ThemeData.dark().copyWith(
      // 修改 highlightColor 和 splashColor 移除 material 按钮特效
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent);

  static ThemeData get light => ThemeData.light().copyWith(
      // 修改 highlightColor 和 splashColor 移除 material 按钮特效
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent);

  static ThemeData of(BuildContext context) {
    AppInfoState appInfoState = ScopedModel.of<AppInfoState>(context);
    AppInfoModel appInfo = appInfoState.state;
    ThemeMode themeMode = appInfo.userProfile.themeMode;
    if (ThemeMode.system == themeMode) {
      return Theme.of(context).brightness == Brightness.dark ? dark : light;
    }

    return ThemeMode.dark == themeMode ? dark : light;
  }
}
