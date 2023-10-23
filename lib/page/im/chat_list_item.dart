import 'package:flutter/material.dart';

class ChatListItemPage extends StatefulWidget {
  const ChatListItemPage({super.key, required this.chatId});

  final String chatId;

  @override
  State<StatefulWidget> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItemPage> {
  @override
  Widget build(BuildContext context) {
    // read chatId from widget
    // user chatService get chat detail
    String chatId = widget.chatId;

    Widget item = Text("this is chat detail : ${widget.chatId}");

    return Container(
      margin: const EdgeInsets.only(top: 2, bottom: 3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black54))
      ),
      // color: Colors.amberAccent,
      child: item,
    );
  }
}
