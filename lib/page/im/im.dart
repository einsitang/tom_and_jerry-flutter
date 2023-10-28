import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nim_core/nim_core.dart';
import 'package:scoped_model/scoped_model.dart';
import "package:tom_and_jerry/config/app_config.dart";
import 'package:tom_and_jerry/page/home.dart';
import 'package:tom_and_jerry/page/im/chat_list.dart';

import '../../model/app_info_model.dart';
import '../../state/app_info_state.dart';

final Logger log = Logger();

class ImPage extends StatefulWidget {
  const ImPage({super.key, required this.title});

  final String title;

  @override
  State<ImPage> createState() => _ImPageState();
}

class _ImPageState extends State<ImPage> {
  // late String _message;

  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  final ChatListPage chatListPage = const ChatListPage();

  void _initPlugins() {
    // ChatKitClient.init();
    // TeamKitClient.init();
    // ConversationKitClient.init();
    // ContactKitClient.init();
    // SearchKitClient.init();
  }

  void _initSDK() {
    String appKey = AppConfig.nIMAppKey;
    NIMSDKOptions options;
    if (Platform.isAndroid) {
      options = NIMAndroidSDKOptions(appKey: appKey);
    } else {
      // iOS
      options = NIMIOSSDKOptions(appKey: appKey);
    }

    if (!NimCore.instance.isInitialized) {
      NimCore.instance.initialize(options).then((result) {
        log.d("-NIM SDK 初始化-");
        log.d(result);
        if (result.isSuccess) {
          // 初始化成功
          log.d("初始化成功");
          _login();
        } else {
          // 初始化失败
          log.e("初始化失败");
        }
      });
    }
  }

  void _login() async {
    String account, token;
    account = "test_2";
    token = "test_2";

    log.d("-NIM SDK 登录-");
    NIMResult loginResult = await NimCore.instance.authService
        .login(NIMLoginInfo(account: account, token: token));

    if (!loginResult.isSuccess) {
      // login failure
      log.e("登录失败");
      return;
    }

    // login success
    log.d("登录成功");

    // 监听消息状态
    NimCore.instance.messageService.onMessageStatus
        .listen((NIMMessage message) {
      log.d("onMessageStatus : ${message.content}");
    });

    // 监听消息
    NimCore.instance.messageService.onMessage.listen((List<NIMMessage> list) {
      for (NIMMessage message in list) {
        log.d("onMessage : ${message.content}");
      }
    });
  }

  // void _sendMessage(String text) async {
  //   String sendAccount = "test_1";
  //   NIMResult<NIMMessage> messageResult =
  //       await MessageBuilder.createTextMessage(
  //           sessionId: sendAccount,
  //           sessionType: NIMSessionType.p2p,
  //           text: text);
  //   if (messageResult.isSuccess) {
  //     NimCore.instance.messageService.sendMessage(message: messageResult.data!);
  //     log.d("发送文本:$text 成功");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _initPlugins();
    _initSDK();
  }

  // final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log.d("im page rebuild...");

    // Widget bodyContentWidget = Column(children: [
    //   TextField(
    //     controller: _messageController,
    //     decoration: const InputDecoration(
    //       border: OutlineInputBorder(),
    //       hintText: 'Enter Message',
    //     ),
    //   ),
    //   IconButton(
    //       icon: const Icon(Icons.mail),
    //       onPressed: () {
    //         _sendMessage(_messageController.text);
    //         _messageController.clear();
    //       })
    // ]);
    //
    // Widget bodyWidget =
    //     Container(padding: const EdgeInsets.all(10), child: bodyContentWidget);

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
                    NetworkImage(_appInfoState.state.userProfile!.avatar!))),
        Container(
            margin: const EdgeInsetsDirectional.fromSTEB(15, 0, 10, 0),
            child: Text("${_appInfoState.state.userProfile!.name} - online",
                style: const TextStyle(fontSize: 16))),
      ]);
    }), onTap: () {
      log.d("jump to page 2");
      const HomePageJumpPageNotification(page: 2).dispatch(context);
    });

    Widget notLoggedInfoWidget = TextButton(
        onPressed: () {
          log.d("jump to page 2");
          const HomePageJumpPageNotification(page: 2).dispatch(context);
        },
        child: const Text("请先登录", style: TextStyle(color: Colors.white)));
    Widget titleWidget =
        ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
          log.d("titleWidget build");
      return _appInfoState.state.loginAuth.isLogin
          ? loggedInfoWidget
          : notLoggedInfoWidget;
    });

    Widget bodyWidget = Scaffold(
        appBar: AppBar(title: titleWidget, actions: [
          ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
            return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {

                });
          }),
          IconButton(
              onPressed: () {
                log.d("search chats");
              },
              icon: const Icon(Icons.search)),
          ScopedModelDescendant<AppInfoState>(builder: (context, child, model) {
            log.d("add button widget build");
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
                chatListPage,
                const Icon(Icons.directions_bike),
              ]),
            )));
    return ScopedModelDescendant<AppInfoState>(
        builder: (context, child, model) => bodyWidget);
  }

  /// 动态构建 add button 组件
  _buildAddButtonWidget(){

    DropdownMenuItem<MenuItem> switchLoginMenuItem(bool isLogin) {
      if (isLogin) {
        return DropdownMenuItem<MenuItem>(
            value: MenuItems.logout, child: MenuItems.buildItem(MenuItems.logout));
      }

      return DropdownMenuItem<MenuItem>(
          value: MenuItems.login, child: MenuItems.buildItem(MenuItems.login));
    }
    DropdownMenuItem<MenuItem> loginOrOutMenuItem = switchLoginMenuItem(_appInfoState.state.loginAuth.isLogin);
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
              8,  // 分割符高度
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
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout, login];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);
  static const login = MenuItem(text: "Log In", icon: Icons.login);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.black, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    AppInfoState appInfoState = ScopedModel.of<AppInfoState>(context);
    LoginAuth loginAuth = appInfoState.state.loginAuth;
    switch (item) {
      case MenuItems.home:
        log.d("home button : ${appInfoState.state.loginAuth.isLogin}");
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
        userProfile.avatar = "https://xsgames.co/randomusers/avatar.php?g=pixel";
        // userProfile.avatar =
        //     "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg";
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
