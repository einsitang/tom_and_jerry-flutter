import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'chat_list_item.dart';

final Logger log = Logger();

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    log.d("chat list page build .");
    Random random = Random();
    return ListView(
        padding: const EdgeInsets.only(top:8.0,bottom: 8.0,left: 5,right: 5),
        children: List.generate(20,
            (index) => ChatListItemPage(
                chatId: "_$index", randomCode: random.nextInt(50))));
  }
}
