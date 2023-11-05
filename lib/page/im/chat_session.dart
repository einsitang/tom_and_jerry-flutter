import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tom_and_jerry/common/app_theme.dart';
import 'package:tom_and_jerry/page/im/chat_session_talk_list.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

final Logger log = Logger();

/// 聊天会话
class ChatSessionPage extends StatefulWidget {
  const ChatSessionPage(
      {super.key, required this.chatId, required this.appInfoState});

  final String chatId;
  final AppInfoState appInfoState;

  @override
  State<StatefulWidget> createState() => _ChatSessionState();
}

class _ChatSessionState extends State<ChatSessionPage> {
  late ScrollController _talkListController;
  late TextEditingController _messageInputController;
  late FocusNode _messageInputFocusNode;

  @override
  void initState() {
    super.initState();
    _talkListController = ScrollController();
    _messageInputController = TextEditingController();
    _messageInputFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      log.d("自动跳转到聊天框底部");
      _talkListController.jumpTo(_talkListController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String chatId = widget.chatId;

    final String chatTitle = "与 $chatId 的聊天";

    ChatSessionTalkListWidget talkListWidget =
        ChatSessionTalkListWidget(_talkListController);

    ThemeData themeData = AppTheme.of(context);

    Widget inputWidget = Container(
      constraints: const BoxConstraints(minHeight: 60),
      decoration: BoxDecoration(
          color: themeData.scaffoldBackgroundColor,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, -3.0), blurRadius: 5.0)
          ]),
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: TextField(
                        controller: _messageInputController,
                        focusNode: _messageInputFocusNode,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration(
                            hintText: "说点什么...",
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder())))),
            IconButton(
                onPressed: () {
                  log.d("send message...");
                  String message = _messageInputController.value.text;
                  if (message.isNotEmpty) {
                    log.d("message : $message");
                    _messageInputController.text = "";
                  }
                  _messageInputFocusNode.unfocus();
                },
                icon: const Icon(Icons.send, size: 32))
          ]),
    );

    Widget talkListWidgetWrapper = GestureDetector(
        onTap: () {
          _messageInputFocusNode.unfocus();
        },
        child: talkListWidget);

    Widget scaffold = Scaffold(
        appBar: AppBar(
          title: Text(chatTitle),
          actions: [
            IconButton(
                onPressed: () {
                  log.d("on tap more");
                  log.d("goto User/Group Profile");
                },
                icon: const Icon(Icons.more_horiz))
          ],
        ),
        body: Column(
            children: [Expanded(child: talkListWidgetWrapper), inputWidget]));

    return scaffold;
  }

  @override
  void dispose() {
    super.dispose();
    _talkListController.dispose();
    _messageInputController.dispose();
    _messageInputFocusNode.dispose();
  }
}
