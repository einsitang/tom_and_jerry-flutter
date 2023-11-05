import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger log = Logger();

class MessageContent {
  final String sessionId;
  final String name;
  final String avatar;
  final String content;

  const MessageContent(this.sessionId, this.name, this.avatar, this.content);
}

const double defaultMessageTextSize = 16;

class ChatSessionTalkListItemWidget extends StatelessWidget {
  const ChatSessionTalkListItemWidget({super.key});

  /// 泡泡框
  // 泡泡框边框颜色
  final Color _bubbleLineColor = Colors.black12;

  // 泡泡框内容背景色
  final Color _leftBubbleCommentsColor = Colors.white;
  final Color _rightBubbleCommentsColor =
      const Color.fromRGBO(0x33, 0xCC, 0x33, 1);

  // 聊天内容样式
  final TextStyle _leftMessageTextStyle = const TextStyle(
      fontSize: defaultMessageTextSize,
      fontWeight: FontWeight.w300,
      color: Colors.black);
  final TextStyle _rightMessageTextStyle = const TextStyle(
      fontSize: defaultMessageTextSize,
      fontWeight: FontWeight.w300,
      color: Colors.white);

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    /// Faker..
    Faker faker = Faker();
    String fakeId = random.nextInt(12).toString();
    // 是否自己发的消息
    bool isSelf = random.nextBool();
    String senderAvatarImg =
        "https://xsgames.co/randomusers/assets/avatars/pixel/$fakeId.jpg";
    String messageBody =
        "I'm a software enginner from China , love develop software and life for it , opensource contributor coding with java / nodejs and go .";

    MessageContent messageContent = MessageContent(
        fakeId, faker.person.name(), senderAvatarImg, messageBody);
    return isSelf
        ? _rightBubbleCommentWidget(context, messageContent)
        : _leftBubbleCommentWidget(context, messageContent);
  }

  /// 占位部件
  Widget _placeholderWidget() {
    return Expanded(flex: 1, child: Container());
  }

  /// 头像组成
  Widget _avatarWidget(String avatarUrl) {
    // 默认 size 40 的 Icon 对象
    icon40(IconData icon) {
      return Icon(icon, size: 40);
    }

    return CircleAvatar(
        radius: 21,
        backgroundColor: Colors.lightBlueAccent,
        child: ClipOval(
            child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (context, url) => icon40(Icons.account_circle_rounded),
          errorWidget: (context, url, error) {
            log.e(error);
            return icon40(Icons.error);
          },
        )));
  }

  /// 左边气泡信息 - 对方聊天内容
  Widget _leftBubbleCommentWidget(
      BuildContext context, MessageContent messageContent) {
    Border arrowBorder = Border(
        left: BorderSide(color: _bubbleLineColor),
        bottom: BorderSide(color: _bubbleLineColor));

    /// 气泡箭头
    Widget arrowWidget = Transform.rotate(
        angle: 3.14158 / 4,
        child: Transform.translate(
            offset: const Offset(4, -4),
            child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: _leftBubbleCommentsColor, border: arrowBorder))));
    Widget indicatorWidget = ClipRect(child: arrowWidget);

    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 头像处
            InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('AlertDialog Title'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: const [
                              Text('举报此消息'),
                              Text('删除此消息'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: _avatarWidget(messageContent.avatar)),

            /// 消息主体
            Expanded(
                flex: 8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// 发送人
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          alignment: Alignment.topLeft,
                          height: 20,
                          child: Text(messageContent.name)),

                      /// 消息内容
                      Stack(children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: _leftBubbleCommentsColor,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1.0, 3.0),
                                      blurRadius: 5.0)
                                ],
                                border: Border.all(color: _bubbleLineColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: SelectableText(
                              messageContent.content,
                              style: _leftMessageTextStyle,
                            )),
                        Positioned(
                            left: 1,
                            child: Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(top: 10),
                                child: indicatorWidget)),
                      ])
                    ])),

            /// 占位符
            _placeholderWidget()
          ],
        ));
  }

  /// 右边气泡信息 - 我方聊天内容
  Widget _rightBubbleCommentWidget(
      BuildContext context, MessageContent messageContent) {
    Border arrowBorder = Border(
        right: BorderSide(color: _bubbleLineColor),
        top: BorderSide(color: _bubbleLineColor));

    /// 气泡箭头
    Widget arrowWidget = Transform.rotate(
        angle: 3.14158 / 4,
        child: Transform.translate(
            offset: const Offset(-4, 4),
            child: Container(
                width: 10,
                height: 10,
                // transform: Matrix4.skewY(0.5),
                decoration: BoxDecoration(
                    color: _rightBubbleCommentsColor, border: arrowBorder))));
    Widget indicatorWidget = ClipRect(child: arrowWidget);
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 15),
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 占位符
            _placeholderWidget(),

            /// 消息主体
            Expanded(
                flex: 8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// 发送人
                      Container(
                          margin: const EdgeInsets.only(right: 10),
                          alignment: Alignment.topRight,
                          height: 20,
                          child: Text(messageContent.name)),

                      /// 消息内容
                      Stack(children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: _rightBubbleCommentsColor,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(-1.0, 3.0),
                                      blurRadius: 5.0)
                                ],
                                border: Border.all(color: _bubbleLineColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Text(messageContent.content,
                                style: _rightMessageTextStyle)),
                        Positioned(
                            right: 1,
                            child: Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(top: 10),
                                child: indicatorWidget)),
                      ])
                    ])),

            /// 头像处
            _avatarWidget(messageContent.avatar),
          ],
        ));
  }
}
