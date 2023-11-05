import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/common/app_theme.dart';
import 'package:tom_and_jerry/config/app_config.dart';
import 'package:tom_and_jerry/model/app_info_model.dart';
import 'package:tom_and_jerry/page/home.dart';
import 'package:tom_and_jerry/page/im/chat_list.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';
import 'package:tom_and_jerry/union_im/model/union_im_message.dart';
import 'package:tom_and_jerry/union_im/nim/nim_provider.dart';
import 'package:tom_and_jerry/union_im/union_im_provider.dart';

final Logger log = Logger();

class ImPage extends StatefulWidget {
  const ImPage({super.key, required this.title});

  final String title;

  @override
  State<ImPage> createState() => _ImPageState();
}

class _ImPageState extends State<ImPage> {
  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  final ChatListWidget chatListWidget = const ChatListWidget();

  _initIM() {
    UnionIMProvider imProvider = NIMProvider.instance;
    if (!imProvider.isInitialized) {
      imProvider
        ..onListener(UnionIMListener(
          onInitSuccess: () {
            imProvider.login("test_1",
                options: {NIMProvider.NIM_LOGIN_TOKEN: "test_1"});
          },
          onInitFail: (String? errorDetails) {
            log.d("init fail : $errorDetails");
          },
          onLoginSuccess: (String account) {
            log.d("login success");
          },
          onLoginFail: (String? errorDetails) {
            log.d("login fail");
          },
          onLogout: (String account) {
            log.d("logout : $account");
          },
          onKickout: () {},
          onAuthExpire: () {},
        ))
        ..onMessageListener(UnionIMMessageListener(
          onChatP2PMessageReceipt: () {},
          onChatP2PMessageReceived: (List<UnionIMMessage> messages) {
            for (UnionIMMessage message in messages) {
              log.d("message content : ${message.content}");
            }
          },
          onChatGroupMessageReceived: () {},
        ))
        ..init({NIMProvider.NIM_APP_KEY: AppConfig.nIMAppKey});
    }
  }

  @override
  void initState() {
    super.initState();
    _initIM();
    log.d("IM page initState");
  }

  @override
  void dispose() {
    super.dispose();
    log.d("IM page dispose");
  }

  @override
  Widget build(BuildContext context) {

    Widget loggedInfoWidget = GestureDetector(child:
        ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
      Color onlineColor = Colors.greenAccent;
      Color offlineColor = Colors.white;

      return Row(children: [
        CircleAvatar(
            radius: 22,
            // 背景颜色形成的效果可以考虑设置 在线(online) 与 不在线(offline)
            backgroundColor: onlineColor,
            child: CircleAvatar(
                radius: 20,
                //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                backgroundImage:
                    NetworkImage(_appInfoState.state.userProfile.avatar!))),
        Container(
            margin: const EdgeInsetsDirectional.fromSTEB(15, 0, 10, 0),
            child: Text("${_appInfoState.state.userProfile.name} - online",
                style: const TextStyle(fontSize: 16))),
      ]);
    }), onTap: () {
      log.d("jump to home page : profile");
      const HomePageJumpPageNotification(tab: HomePageTab.PROFILE)
          .dispatch(context);
    });

    Widget notLoggedInfoWidget = TextButton(
        onPressed: () {
          log.d("jump to home page : profile");
          const HomePageJumpPageNotification(tab: HomePageTab.PROFILE)
              .dispatch(context);
        },
        child: const Text("请先登录", style: TextStyle(color: Colors.white)));
    Widget titleWidget =
        ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
      return _appInfoState.state.loginAuth.isLogin
          ? loggedInfoWidget
          : notLoggedInfoWidget;
    });

    Widget bodyWidget = Scaffold(
        appBar: AppBar(title: titleWidget, actions: [
          ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
            return IconButton(icon: const Icon(Icons.login), onPressed: () {});
          }),
          IconButton(
              onPressed: () {
                log.d("search chats");
              },
              icon: const Icon(Icons.search)),
          ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
            return _buildAddButtonWidget();
          }),
        ]),
        body: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: const TabBar(tabs: [
                  Tab(text: "对话列表"),
                  Tab(text: "好友列表"),
                ]),
              ),
              body: TabBarView(children: [
                chatListWidget,
                const Icon(Icons.directions_bike),
              ]),
            )));
    return ScopedModelDescendant<AppInfoState>(
        builder: (context, child, model) =>
            Theme(data: AppTheme.of(context), child: bodyWidget));
  }

  /// 动态构建 add button 组件
  _buildAddButtonWidget() {
    DropdownMenuItem<MenuItem> switchLoginMenuItem(bool isLogin) {
      if (isLogin) {
        return DropdownMenuItem<MenuItem>(
            value: MenuItems.logout,
            child: MenuItems.buildItem(MenuItems.logout));
      }

      return DropdownMenuItem<MenuItem>(
          value: MenuItems.login, child: MenuItems.buildItem(MenuItems.login));
    }

    DropdownMenuItem<MenuItem> loginOrOutMenuItem =
        switchLoginMenuItem(_appInfoState.state.loginAuth.isLogin);

    DropdownButtonHideUnderline addButtonWidget = DropdownButtonHideUnderline(
        child: DropdownButton2(
      customButton: const SizedBox(width: 50, child: Icon(Icons.add)),
      items: [
        ...MenuItems.firstItems.map(
          (item) => DropdownMenuItem<MenuItem>(
            value: item,
            child: MenuItems.buildItem(item),
          ),
        ),
        const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
        loginOrOutMenuItem,
        // ...MenuItems.secondItems.map(
        //   (item) => DropdownMenuItem<MenuItem>(
        //     value: item,
        //     child: MenuItems.buildItem(item),
        //   ),
        // ),
      ],
      onChanged: (value) {
        MenuItems.onChanged(context, value! as MenuItem);
      },
      dropdownStyleData: DropdownStyleData(
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          // color: Colors.redAccent,
        ),
        offset: const Offset(0, 8),
      ),
      menuItemStyleData: MenuItemStyleData(
        customHeights: [
          ...List<double>.filled(MenuItems.firstItems.length, 48),
          8, // 分割符高度
          48, // login / logout 高度
        ],
        padding: const EdgeInsets.only(left: 16, right: 16),
      ),
    ));

    return addButtonWidget;
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [addUser, share, settings];
  static const List<MenuItem> secondItems = [logout, login];

  static const addUser =
      MenuItem(text: 'Add User', icon: Icons.person_add_alt_outlined);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);
  static const login = MenuItem(text: "Log In", icon: Icons.login);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(item.text),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    AppInfoState appInfoState = ScopedModel.of<AppInfoState>(context);
    LoginAuth loginAuth = appInfoState.state.loginAuth;
    switch (item) {
      case MenuItems.addUser:
        log.d("add user button : ${appInfoState.state.loginAuth.isLogin}");
        break;
      case MenuItems.settings:
        //Do something
        log.d("on settings button");
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.login:
        loginAuth.accessToken = "isLogin";
        UserProfile userProfile = UserProfile();
        userProfile.avatar =
            "https://xsgames.co/randomusers/avatar.php?g=pixel";
        userProfile.name = "爱因斯唐";
        appInfoState.updateUserProfile(userProfile);
        appInfoState.updateLoginAuth(loginAuth);
        break;
      case MenuItems.logout:
        //Do something
        loginAuth.accessToken = null;
        appInfoState.updateLoginAuth(loginAuth);
        break;
    }
  }
}
