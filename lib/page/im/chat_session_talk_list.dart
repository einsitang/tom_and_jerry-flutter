import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tom_and_jerry/page/im/chat_session_talk_list_item.dart';

final Logger log = Logger();

class ChatSessionTalkListWidget extends StatefulWidget {
  final ScrollController _talkListController;

  const ChatSessionTalkListWidget(this._talkListController, {super.key});

  @override
  State<StatefulWidget> createState() => _ChatSessionTalkListState();
}

class _ChatSessionTalkListState extends State<ChatSessionTalkListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: widget._talkListController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ChatSessionTalkListItemWidget();
        });
  }
}
