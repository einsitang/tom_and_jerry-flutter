import 'package:tom_and_jerry/union_im/model/union_im_chat.dart';

/// 消息类型
enum UnionIMMessageType { TEXT, IMAGE, AUDIO, VIDEO, FILE, LOCATION }

class UnionIMMessageTypeMapping<T> {
  final Map<T, UnionIMMessageType> mapper = {};

  register(T t, UnionIMMessageType unionIMMessageType) {
    mapper[t] = unionIMMessageType;
  }

  match(T t) => mapper[t];
}

enum UnionIMMessageDirection {
  /// 发送消息
  OUTGOING,

  /// 接受消息
  RECEIVED
}

class UnionIMMessageDirectionMapping<T> {
  final Map<T, UnionIMMessageDirection> mapper = {};

  register(T t, UnionIMMessageDirection unionIMMessageDirection) {
    mapper[t] = unionIMMessageDirection;
  }

  match(T t) => mapper[t];
}

class UnionIMMessage {
  String? id;
  final String chatId;
  final UnionIMChatType chatType;
  final String fromAccount;
  final String fromNickname;
  final UnionIMMessageType messageType;
  String? content;
  UnionIMMessageAttachment? attachment;
  final DateTime timestamp;
  int? status;
  final UnionIMMessageDirection messageDirection;

  UnionIMMessage(
      {this.id,
      required this.chatId,
      required this.chatType,
      required this.fromAccount,
      required this.fromNickname,
      required this.messageType,
      this.content,
      this.attachment,
      required this.timestamp,
      this.status,
      required this.messageDirection})
      : assert(messageType == UnionIMMessageType.TEXT && content == null),
        assert(messageType != UnionIMMessageType.TEXT && attachment == null);
}

/// 消息附件
class UnionIMMessageAttachment {
  late final String filePath;
  late final int fileSize;
  Duration? duration;
}
