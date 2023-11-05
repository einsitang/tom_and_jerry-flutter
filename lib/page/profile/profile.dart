import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:tom_and_jerry/common/app_theme.dart';
import 'package:tom_and_jerry/model/app_info_model.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

final Logger log = Logger();

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.title});

  final String title;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  @override
  void initState() {
    super.initState();
    log.d("profile page initState");
  }

  SvgPicture _svgIcon(
      String label, String assetName, double width, double height,
      {bool isLightUp = false}) {
    return SvgPicture.asset(assetName,
        width: width,
        height: height,
        semanticsLabel: label,
        colorFilter: ColorFilter.mode(
            isLightUp
                ? AppTheme.of(context).scaffoldBackgroundColor
                : AppTheme.of(context).secondaryHeaderColor.withAlpha(128),
            BlendMode.srcIn));
  }

  @override
  Widget build(BuildContext context) {
    log.d("profile page rebuild....");
    ThemeData appThemeData = AppTheme.of(context);

    String userAvatarImg = "https://xsgames.co/randomusers/avatar.php?g=pixel";
    String mobile = "156*****898";
    String name = "EinsiTang";
    String nickName = "爱因斯唐";

    SvgPicture svgGithub =
        _svgIcon("Github", "assets/svg/github.svg", 25, 25, isLightUp: true);
    SvgPicture svgWechat = _svgIcon("Wechat", "assets/svg/wechat.svg", 25, 25);
    SvgPicture svgAlipay = _svgIcon("Github", "assets/svg/alipay.svg", 25, 25);

    bool enableDarkMode;
    UserProfile userProfile = _appInfoState.state.userProfile;
    if (userProfile.themeMode == ThemeMode.system) {
      enableDarkMode = AppTheme.of(context).brightness == Brightness.dark;
    } else {
      enableDarkMode = userProfile.themeMode == ThemeMode.dark;
    }

    // 默认 size 128 的 Icon 对象
    icon128(IconData icon) {
      return Icon(icon, size: 128);
    }

    Widget circleAvatarWidget = CircleAvatar(
        radius: 65,
        backgroundColor: Colors.lightBlueAccent,
        child: ClipOval(
            child: CachedNetworkImage(
          width: 128,
          height: 128,
          imageUrl: userAvatarImg,
          fit: BoxFit.cover,
          placeholder: (context, url) => icon128(Icons.account_circle_rounded),
          errorWidget: (context, url, error) {
            log.e(error);
            return icon128(Icons.error);
          },
        )));
    Widget bannerWidget = Container(
        color: appThemeData.primaryColor,
        height: 360,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: circleAvatarWidget),
          Container(
              height: 40,
              alignment: Alignment.center,
              // color: Colors.yellow,
              child: Text(nickName,
                  style: const TextStyle(color: Colors.white, fontSize: 26))),
          Container(
              height: 30,
              alignment: Alignment.center,
              child: Wrap(spacing: 5, children: [
                Text(mobile,
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 16)),
                Text("• @$name",
                    style: const TextStyle(color: Colors.white60, fontSize: 16))
              ])),
          SizedBox(
              height: 40,
              child:
                  Wrap(spacing: 8, children: [svgGithub, svgWechat, svgAlipay]))
        ]));

    SettingsList settingsListWidget = SettingsList(
      sections: [
        SettingsSection(title: const Text("Profile"), tiles: <SettingsTile>[
          SettingsTile.navigation(
            leading: const Icon(Icons.phone_iphone),
            title: const Text("Mobile Number"),
            value: Text(mobile),
          ),
          SettingsTile.navigation(
            leading: svgGithub,
            title: const Text("Github"),
            value: const Text("已绑定"),
          ),
          SettingsTile.navigation(
            leading: svgWechat,
            title: const Text("Wechat"),
            value: const Text("未绑定"),
          ),
        ]),
        SettingsSection(
          title: const Text('Settings'),
          tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: const Text('English'),
            ),
            SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    enableDarkMode = value;
                  });

                  UserProfile? userProfile = _appInfoState.state.userProfile;
                  userProfile.name = "爱因斯唐";
                  userProfile.themeMode =
                      value ? ThemeMode.dark : ThemeMode.light;
                  _appInfoState.updateUserProfile(userProfile);

                  log.d("value : $value");
                },
                initialValue: enableDarkMode,
                leading: const Icon(Icons.format_paint),
                title: const Text('Enable Dark theme')),
          ],
        ),
      ],
    );

    Widget bodyWidget =
        Column(children: [bannerWidget, Expanded(child: settingsListWidget)]);

    return ScopedModelDescendant<AppInfoState>(
        builder: (context, child, model) =>
            // bodyWidget);
            Theme(data: AppTheme.of(context), child: bodyWidget));
  }
}
