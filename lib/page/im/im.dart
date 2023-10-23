import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nim_core/nim_core.dart';
import 'package:tom_and_jerry/page/im/chat_list.dart';
import "package:tom_and_jerry/config/app_config.dart";

final Logger log = Logger();

class ImPage extends StatefulWidget {
  const ImPage({super.key, required this.title});

  final String title;

  @override
  State<ImPage> createState() => _ImPageState();
}

class _ImPageState extends State<ImPage> {
  late String _message;

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

  void _sendMessage(String text) async {
    String sendAccount = "test_1";
    NIMResult<NIMMessage> messageResult =
        await MessageBuilder.createTextMessage(
            sessionId: sendAccount,
            sessionType: NIMSessionType.p2p,
            text: text);
    if (messageResult.isSuccess) {
      NimCore.instance.messageService.sendMessage(message: messageResult.data!);
      log.d("发送文本:$text 成功");
    }
  }

  @override
  void initState() {
    super.initState();
    _initPlugins();
    _initSDK();
  }

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ChatListPage chatListPage = const ChatListPage();

    Widget bodyContentWidget = Column(children: [
      TextField(
        controller: _messageController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Message',
        ),
      ),
      IconButton(
          icon: const Icon(Icons.mail),
          onPressed: () {
            _sendMessage(_messageController.text);
            _messageController.clear();
          })
    ]);

    Widget bodyWidget =
        Container(padding: const EdgeInsets.all(10), child: bodyContentWidget);

    return Scaffold(
        appBar: AppBar(title: Text(widget.title), actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                log.d("search chats");
              }),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                log.d("leading on tap");
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
  }
}
