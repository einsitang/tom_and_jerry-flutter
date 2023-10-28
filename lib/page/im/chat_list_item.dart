import 'dart:math';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class ChatListItemPage extends StatefulWidget {
  const ChatListItemPage(
      {super.key, required this.chatId, required this.randomCode});

  final String chatId;
  final int randomCode;

  @override
  State<StatefulWidget> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItemPage> {
  Color _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    // read chatId from widget
    // user chatService get chat detail

    int randUnReadCount = Random().nextInt(99);

    String mockAvatarImg =
        "https://xsgames.co/randomusers/assets/avatars/pixel/${widget.randomCode}.jpg";

    /// 头像
    CircleAvatar chatAvatar = CircleAvatar(
        radius: 33,
        backgroundColor: Colors.lightBlueAccent,
        child: ClipOval(
            child: CachedNetworkImage(
          width: 64,
          height: 64,
          imageUrl: mockAvatarImg,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Icon(Icons.account_circle_rounded,size: 64),
          errorWidget: (context, url, error) {
            log.e(error);
            return const Icon(Icons.error,size:64);
          },
        )));

    Widget chatTitle = Row(children: [
      /// 对话标题
      Expanded(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("邢道荣_${widget.chatId}",
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold)))),

      /// 时间
      Container(
          width: 120,
          alignment: Alignment.topRight,
          child: const Text("19:23", style: TextStyle(color: Colors.black54)))
    ]);

    Widget chatDigest = Row(children: [
      /// 对话摘要
      const Expanded(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "吾乃零陵上将邢道荣.............尔等受死。。。.%^#^#^^^&%%@%!^@%^@%@^@%@^%@&!&%#&@%@^%@&!&%#&@%@^%@&!&%#&@死受死受死",
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                  style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.normal)))),

      /// 小红点
      Container(
          width: 30,
          alignment: Alignment.centerRight,
          child: badges.Badge(
              showBadge: randUnReadCount > 0,
              badgeContent: Text("$randUnReadCount",
                  style: const TextStyle(color: Colors.white))))
    ]);

    Widget chatInfo = Column(children: [
      SizedBox(height: 20, child: chatTitle),
      SizedBox(height: 45, child: chatDigest)
    ]);

    AnimatedContainer chatListItemWidget = AnimatedContainer(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      padding: const EdgeInsets.only(left: 5, right: 5),
      height: 80,
      decoration: BoxDecoration(
          color: _color,
          // border: const Border(bottom: BorderSide(color: Colors.black12)),
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
      curve: Curves.linearToEaseOut,
      duration: const Duration(milliseconds: 300),
      child: Row(children: [
        Container(
            width: 80, alignment: Alignment.centerLeft, child: chatAvatar),
        Expanded(
            child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: chatInfo))
      ]),
    );

    return GestureDetector(
        child: chatListItemWidget,
        onTap: () {
          log.d("点击");
        },
        onLongPress: () {
          log.d("长按 : ${widget.chatId}");
          showDialog<void>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('This is a demo alert dialog.'),
                        Text('Would you like to approve of this message?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Approve'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
          setState(() {
            _color = Colors.white;
          });
        },
        onLongPressDown: (LongPressDownDetails details) {
          setState(() {
            _color = Colors.lightBlue.shade100;
            // _color = const Color.fromRGBO(0x38, 0xB0, 0xDE, 0.8);
          });
        },
        onLongPressUp: () {
          setState(() {
            _color = Colors.white;
          });
        },
        onLongPressStart: (LongPressStartDetails details) {
          setState(() {
            _color = Colors.white;
          });
        },
        onLongPressEnd: (LongPressEndDetails details) {
          setState(() {
            _color = Colors.white;
          });
        },
        onLongPressCancel: () {
          setState(() {
            _color = Colors.white;
          });
        });
  }
}
