import 'dart:math';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tom_and_jerry/common/app_theme.dart';
import 'package:tom_and_jerry/page/im/chat_session.dart';
import 'package:tom_and_jerry/state/app_info_state.dart';

final Logger log = Logger();

class ChatListItemWidget extends StatefulWidget {
  const ChatListItemWidget(
      {super.key, required this.chatId, required this.randomCode});

  final String chatId;
  final int randomCode;

  @override
  State<StatefulWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListItemWidget> {
  /// 背景颜色
  Color? _backgroundColor;

  late final Color _hoverBackgroundColor;
  late final Color _normalBackgroundColor;

  AppInfoState get _appInfoState => ScopedModel.of<AppInfoState>(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ThemeData themeData = AppTheme.of(context);
    _hoverBackgroundColor = themeData.hoverColor;
    _normalBackgroundColor = themeData.scaffoldBackgroundColor;
    _backgroundColor ??= _normalBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    // read chatId from widget
    // user chatService get chat detail

    ThemeData themeData = AppTheme.of(context);

    int randUnReadCount = Random().nextInt(99);
    DateTime randomDateTime =
        DateTime.now().add(Duration(seconds: -(Random().nextInt(91765) + 60)));
    String briefDayFormat = TimelineUtil.formatByDateTime(randomDateTime,
        locale: "zh", dayFormat: DayFormat.Common);

    String mockAvatarImg =
        "https://xsgames.co/randomusers/assets/avatars/pixel/${widget.randomCode}.jpg";

    // 默认 size 64 的 Icon 对象
    icon64(IconData icon) {
      return Icon(icon, size: 64);
    }

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
          placeholder: (context, url) => icon64(Icons.account_circle_rounded),
          errorWidget: (context, url, error) {
            log.e(error);
            return icon64(Icons.error);
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
          width: 130,
          alignment: Alignment.topRight,
          child: Text(briefDayFormat, style: themeData.textTheme.bodySmall))
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
                  style: TextStyle(fontSize: 12)))),

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

    Container chatListItemWidget = Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      padding: const EdgeInsets.only(left: 5, right: 5),
      height: 80,
      decoration: BoxDecoration(
          //color: themeData.scaffoldBackgroundColor,
          color: _backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(1.0, 1.0),
                blurRadius: 0.5)
          ]),
      child: Row(children: [
        Container(
            width: 80, alignment: Alignment.centerLeft, child: chatAvatar),
        Expanded(
            child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: chatInfo))
      ]),
    );

    return InkWell(
        child: chatListItemWidget,
        onTap: () {
          log.d("goto tap chat session page");
          ThemeData themeData = AppTheme.of(context);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            var scopedModelWidget = ScopedModel<AppInfoState>(
                model: _appInfoState,
                child: ChatSessionPage(
                    chatId: widget.chatId, appInfoState: _appInfoState));
            return Theme(data: themeData, child: scopedModelWidget);
          }));
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
        onHighlightChanged: (value) {
          setState(() {
            if (value) {
              _backgroundColor = _hoverBackgroundColor;
            } else {
              _backgroundColor = _normalBackgroundColor;
            }
          });
        });
  }
}
