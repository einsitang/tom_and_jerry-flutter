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
    return ListView(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 106.0,
      children: List.generate(10, (index) => ChatListItemPage(chatId:"_$index"))
    );
  }

}
