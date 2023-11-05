import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tom_and_jerry/page/im/chat_list_item.dart';

import 'package:tom_and_jerry/common/app_theme.dart';

final Logger log = Logger();

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({super.key});

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {

    Random random = Random();

    return ListView.builder(
        controller: _scrollController,
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 5, right: 5),
        itemCount: 20,
        itemBuilder: (context, int position) {
          return Theme(
            data: AppTheme.of(context),
            child: ChatListItemWidget(
                chatId: "_$position", randomCode: random.nextInt(50)),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
